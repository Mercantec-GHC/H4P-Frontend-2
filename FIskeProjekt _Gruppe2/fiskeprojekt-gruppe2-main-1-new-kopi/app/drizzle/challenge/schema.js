import { pgTable, serial, text, boolean, timestamp } from "drizzle-orm/pg-core";
import { users } from "../user/schema";
import { relations } from "drizzle-orm";

const challenges = pgTable("challenges", {
    id: serial("id").primaryKey(),
    info: text("info").notNull(),
    title: text("title").notNull(),
    userId: serial("user_id").references(() => users.id).notNull(),
});

const challengesRelations = relations(challenges, ({ one }) => ({
    author: one(users, {
        foreignKey: "userId"
    }),
  }));

export { challenges, challengesRelations };


