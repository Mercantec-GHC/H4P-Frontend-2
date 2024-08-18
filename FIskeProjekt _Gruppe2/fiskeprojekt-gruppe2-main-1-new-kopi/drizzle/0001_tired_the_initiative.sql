ALTER TABLE "users" RENAME COLUMN "id" TO "userId";--> statement-breakpoint
ALTER TABLE "challenges" ADD COLUMN "title" text NOT NULL;--> statement-breakpoint
ALTER TABLE "challenges" ADD COLUMN "user_id" serial NOT NULL;--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "challenges" ADD CONSTRAINT "challenges_user_id_users_userId_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("userId") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
