[1mdiff --git a/Application/Schema.sql b/Application/Schema.sql[m
[1mindex b743c66..f27abad 100644[m
[1m--- a/Application/Schema.sql[m
[1m+++ b/Application/Schema.sql[m
[36m@@ -1 +1,16 @@[m
[32m+[m[32mCREATE FUNCTION set_updated_at_to_now() RETURNS TRIGGER AS $$[m
[32m+[m[32mBEGIN[m
[32m+[m[32m    NEW.updated_at = NOW();[m
[32m+[m[32m    RETURN NEW;[m
[32m+[m[32mEND;[m
[32m+[m[32m$$ language plpgsql;[m
 -- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.[m
[32m+[m[32mCREATE TABLE posts ([m
[32m+[m[32m    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,[m
[32m+[m[32m    title TEXT NOT NULL,[m
[32m+[m[32m    body TEXT NOT NULL,[m
[32m+[m[32m    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,[m
[32m+[m[32m    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL[m
[32m+[m[32m);[m
[32m+[m[32mCREATE INDEX posts_created_at_index ON posts (created_at);[m
[32m+[m[32mCREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON posts FOR EACH ROW EXECUTE FUNCTION set_updated_at_to_now();[m
[1mdiff --git a/Main.hs b/Main.hs[m
[1mindex 81d4d95..be5faf8 100644[m
[1m--- a/Main.hs[m
[1m+++ b/Main.hs[m
[36m@@ -6,9 +6,13 @@[m [mimport qualified IHP.Server[m
 import IHP.RouterSupport[m
 import IHP.FrameworkConfig[m
 import IHP.Job.Types[m
[32m+[m[32mimport Web.FrontController[m
[32m+[m[32mimport Web.Types[m
 [m
 instance FrontController RootApplication where[m
[31m-    controllers = [][m
[32m+[m[32m    controllers = [[m
[32m+[m[32m            mountFrontController WebApplication[m
[32m+[m[32m        ][m
 [m
 instance Worker RootApplication where[m
     workers _ = [][m
