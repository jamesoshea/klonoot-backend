CREATE DATABASE klonoot;

\c klonoot
CREATE EXTENSION pgcrypto;

CREATE EXTENSION pgjwt;

BEGIN;
--------------------------------------------------------------------------------
-- We use JSON Web Tokens to authenticate API requests. PostgREST
-- cares specifically about a claim called role. When request
-- contains a valid JWT with a role claim PostgREST will switch
-- to the database role with that name for the duration of the
-- HTTP request. If the client included no (or an invalid) JWT
-- then PostgREST selects the role "anonymous".
CREATE ROLE anonymous;
CREATE ROLE web_user;
GRANT anonymous, web_user TO authenticator;
GRANT USAGE ON SCHEMA public TO anonymous, web_user;
--------------------------------------------------------------------------------
-- The user id is a string stored in postgrest.claims.sub. Let's
-- wrap this in a nice function.
CREATE FUNCTION current_user_id()
    RETURNS uuid STABLE
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN current_setting('postgrest.claims.userid');
EXCEPTION
    -- handle unrecognized configuration parameter error
    WHEN undefined_object THEN
        RETURN '';
END;
$$;
GRANT EXECUTE ON FUNCTION current_user_id() TO anonymous, web_user;
--------------------------------------------------------------------------------
-- We put things inside the hidden schema to hide
-- them from public view. Certain public procs/views will
-- refer to helpers and tables inside.
CREATE SCHEMA hidden;
CREATE TABLE hidden.users(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    "createdAt" timestamp NOT NULL DEFAULT now(),
    "updatedAt" timestamp NOT NULL DEFAULT now(),
    username text NOT NULL,
    "password" text NOT NULL,
    role text NOT NULL CHECK (length(ROLE) < 50),
    CONSTRAINT users_id_key UNIQUE (id)
);
CREATE FUNCTION hidden.encrypt_pass()
    RETURNS TRIGGER
    AS $$
BEGIN
    IF tg_op = 'INSERT' OR NEW."password" <> OLD."password" THEN
        NEW."password" = crypt(NEW."password", gen_salt('bf', 12));
    END IF;
    RETURN new;
END;
$$
LANGUAGE plpgsql;
CREATE TRIGGER encrypt_pass
    BEFORE INSERT OR UPDATE ON hidden.users
    FOR EACH ROW
    EXECUTE PROCEDURE hidden.encrypt_pass();
CREATE FUNCTION hidden.user_role(username text, pass text)
    RETURNS name
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN(
        SELECT
            ROLE
        FROM
            hidden.users
        WHERE
            users.username = user_role.username
            AND users.password = crypt(user_role.pass, users.password));
END;
$$;
CREATE FUNCTION public.login(username text, pass text, out token text)
AS $$
DECLARE
    _role name;
BEGIN
    SELECT
        hidden.user_role(username, pass) INTO _role;
    IF _role IS NULL THEN
        RAISE invalid_password
        USING message = 'Invalid username or password';
    END IF;
        SELECT
            sign(row_to_json(r), current_setting('app.settings.JWT_SECRET')) AS token
        FROM (
            SELECT
                _role AS role,
                login.username AS username,
                extract(epoch FROM now())::integer + 60 * 60 AS exp) r INTO token;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER;
GRANT usage ON SCHEMA hidden TO anonymous, web_user;
GRANT EXECUTE ON FUNCTION public.login TO anonymous, web_user;
COMMIT;

