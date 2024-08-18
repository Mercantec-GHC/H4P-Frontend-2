"use server";

import { neon } from "@neondatabase/serverless";
import bcrypt from "bcrypt";
import { drizzle } from "drizzle-orm/neon-http";
import { users } from "../drizzle/user/schema";

export async function createUser({ username, password }) {
    try {
        const sql = neon(process.env.DATABASE_URL);

        const hashedPassword = await bcrypt.hash(password, 10);

        const db = drizzle(sql, { users });

        //Add user
        const data = await db
            .insert(users)
            .values({ username: username, password: hashedPassword });

        return { status: 200, data };
    } catch (error) {
        console.log(error);
        return { error };
    }
}
