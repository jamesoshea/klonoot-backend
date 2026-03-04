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

CREATE FUNCTION current_user_id() RETURNS uuid
STABLE
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN current_setting('postgrest.claims.userid');
EXCEPTION
	-- handle unrecognized configuration parameter error
	WHEN undefined_object THEN RETURN '';
END;
$$;

GRANT EXECUTE ON FUNCTION current_user_id() TO anonymous, web_user;

--------------------------------------------------------------------------------
-- We put things inside the hidden schema to hide
-- them from public view. Certain public procs/views will
-- refer to helpers and tables inside.

CREATE SCHEMA hidden;

CREATE TABLE hidden.users (
	id            uuid      	not null default gen_random_uuid(),
	"createdAt"   timestamp 	not null default now(),
	"updatedAt"	  timestamp 	not null default now(),
	username	  text 			not null,

	constraint 	  users_id_key unique (id)
);

COMMIT;
