// middleware/auth.js

import { verifyToken } from "@/utils/jwt";

export function authenticate(req) {
    const authHeader = req.headers.get("Authorization");
    const token = authHeader && authHeader.split(" ")[1];
    console.log(token);

    if (!token) {
        return new Response(JSON.stringify({ error: "No token provided" }), {
            status: 403,
            headers: {
                "Content-Type": "application/json",
            },
        });
    }

    const user = verifyToken(token);

    if (!user) {
        return new Response(JSON.stringify({ error: "Invalid token" }), {
            status: 403,
            headers: {
                "Content-Type": "application/json",
            },
        });
    }

    // Attach user info to the request if needed
    req.user = user;

    // Proceed with the request
    return null; // or you can return a success response, but typically you'd return null here to indicate success
}
