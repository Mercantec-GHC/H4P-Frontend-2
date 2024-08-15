"use server";
import { neon } from "@neondatabase/serverless";
import { drizzle } from "drizzle-orm/neon-http";
import { users } from "../drizzle/user/schema";
import { revalidatePath } from "next/cache";

export async function getData() {
    const sql = neon(process.env.DATABASE_URL);
    const db = drizzle(sql, { users });
    //Get all users from the database
    const result = await db.select().from(users);

    console.log(result);

    revalidatePath("/");
    return result;
}
