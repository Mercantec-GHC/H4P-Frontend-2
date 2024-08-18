// utils/jwt.js

import jwt from "jsonwebtoken";

const SECRET_KEY = process.env.JWT_SECRET || "your-secret-key"; // Use a strong secret key in production

export function generateToken(payload) {
    return jwt.sign(payload, SECRET_KEY, { expiresIn: "1h" }); // Token expires in 1 hour
}

export function verifyToken(token) {
    try {
        return jwt.verify(token, SECRET_KEY);
    } catch (error) {
        return null;
    }
}
