"use server";

import { neon } from "@neondatabase/serverless";
import bcrypt from "bcrypt";
import { drizzle } from "drizzle-orm/neon-http";
import { eq } from "drizzle-orm/expressions";
import { users } from "../drizzle/user/schema";
import { generateToken } from "@/utils/jwt";

export async function loginUser({ username, password }) {
    console.log("Logging in user");
    try {
        const sql = neon(process.env.DATABASE_URL);
        const db = drizzle(sql, { users });

        // Fetch user by username
        let user = await db.select().from(users).where(eq(users.username, username));

        if (!user) {
            return { status: 401, error: "Invalid credentials" };
        } else {
            console.log(user);
            user = user[0];
        }

        // Compare passwords
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            return { status: 401, error: "Invalid credentials" };
        } else {
            console.log("Password is valid");
        }

        // Generate JWT
        const token = generateToken({ id: user.id, username: user.username });

        return { status: 200, token };
    } catch (error) {
        console.log(error);
        return { error };
    }
}
