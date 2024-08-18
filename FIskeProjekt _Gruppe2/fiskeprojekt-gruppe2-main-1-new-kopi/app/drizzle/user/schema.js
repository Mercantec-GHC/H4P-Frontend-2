import { pgTable, serial, text, boolean, timestamp } from "drizzle-orm/pg-core";
import { relations } from "drizzle-orm";
import { challenges } from "../challenge/schema";


const users = pgTable("users", {
    id: serial("userId").primaryKey(),
    username: text("username").notNull(),
    password: text("password").notNull(),
});

const usersRelations = relations(users, ({ many }) => ({
    challenges: many(challenges),
  }));

export { users, usersRelations };
