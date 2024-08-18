"use server";

import { neon } from "@neondatabase/serverless";
import { drizzle } from "drizzle-orm/neon-http";
import { users } from "../drizzle/user/schema";
import { eq } from "drizzle-orm";

export async function deleteUser({ username }) {
    try {
        const sql = neon(process.env.DATABASE_URL);
        const db = drizzle(sql, { users });

        //Add user
        const data = await db
            .delete(users)
            .where(eq(users.username, username));

            if (data.rowCount === 0) {
                return { status: 404, message: "User not found" };
            }

        return { status: 200, message: "User deleted successfully" };
    } catch (error) {
        console.log(error);
        return { status: 500, error };
    }
}