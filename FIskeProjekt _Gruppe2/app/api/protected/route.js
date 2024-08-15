import { authenticate } from "@/middleware/auth";

export async function POST(req) {
    const authResponse = authenticate(req);

    if (authResponse) {
        return authResponse; // This will return the error response from authenticate if the token is invalid
    }

    console.log("You are authenticated");

    // If authentication is successful, proceed with the protected logic
    return new Response(JSON.stringify({ message: "You are authenticated" }), {
        status: 200,
        headers: {
            "Content-Type": "application/json",
        },
    });
}
