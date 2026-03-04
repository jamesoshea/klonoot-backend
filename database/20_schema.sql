BEGIN;

--------------------------------------------------------------------------------

CREATE TABLE routes (
	id          		uuid   	  			primary key
											not null
											default gen_random_uuid(),
	"userId"      		uuid        		not null
	            				        	default current_user_id()
	                          				references hidden.users (id),
	"createdAt"     	timestamp   		not null
	                          				default now(),
	"brouterProfile"    character varying   not null,
	points 				jsonb 				null
											default '[]'::jsonb,
	name 				text 				not null
											default ''::text,

  	constraint 			routes_id_key 		unique (id),
  	constraint 			routes_name_check 	check ((length(name) <= 100))
);

-- Author can insert and modify
GRANT SELECT,
	INSERT,
	UPDATE,
	DELETE
ON TABLE routes TO web_user;

-- …but only of rows that they created themselves.
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;

CREATE POLICY web_user_own_select ON routes FOR SELECT
	USING ("userId" = current_user_id());

CREATE POLICY web_user_own_create ON routes FOR INSERT
	WITH CHECK ("userId" = current_user_id());

CREATE POLICY web_user_own_update ON routes FOR UPDATE
	WITH CHECK ("userId" = current_user_id());

CREATE POLICY web_user_own_delete ON routes FOR DELETE
	USING ("userId" = current_user_id());

--------------------------------------------------------------------------------


CREATE TABLE pois (
  id 			uuid 						NOT NULL
  											DEFAULT gen_random_uuid(),
  "createdAt" 	timestamp with time zone	NOT NULL DEFAULT now(),
  name 			character varying			NOT NULL,
  "routeId" 	uuid 						NOT NULL
											REFERENCES hidden.users (id),
  coordinates 	json 						NOT NULL,
  category 		character varying 			NOT NULL,
  "userId" 		uuid 						NOT NULL
	            				        	default current_user_id(),
  CONSTRAINT 	pois_pkey 					PRIMARY KEY (id),
  CONSTRAINT 	"pois_userId_fkey" 			FOREIGN KEY ("userId") REFERENCES hidden.users(id)
);

-- Author can insert and modify name and description…
GRANT SELECT,
	INSERT,
	UPDATE,
	DELETE
ON TABLE pois TO web_user;

-- …but only of rows that they created themselves.
ALTER TABLE pois ENABLE ROW LEVEL SECURITY;

CREATE POLICY web_user_own_select ON pois FOR SELECT
	USING ("userId" = current_user_id());

CREATE POLICY web_user_own_create ON pois FOR INSERT
	WITH CHECK ("userId" = current_user_id());

CREATE POLICY web_user_own_update ON pois FOR UPDATE
	WITH CHECK ("userId" = current_user_id());

CREATE POLICY web_user_own_delete ON pois FOR DELETE
	USING ("userId" = current_user_id());

COMMIT;
