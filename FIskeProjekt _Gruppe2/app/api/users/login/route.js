import { loginUser } from "@/app/actions/loginUser";

export async function POST(req) {
    console.log("Logging in user");
    try {
        const formData = await req.formData();

        let username = formData.get("username");
        console.log(username);
        let password = formData.get("password");
        console.log(password);

        let res = await loginUser({ username, password }).then((data) => {
            console.log(data);
            return data;
        });

        if (res.status === 200) {
            return new Response(JSON.stringify({ token: res.token }), {
                status: 200,
                headers: {
                    "Content-Type": "application/json",
                },
            });
        } else {
            return new Response(JSON.stringify({ error: res.error }), {
                status: 401,
                headers: {
                    "Content-Type": "application/json",
                },
            });
        }
    } catch (error) {
        console.log(error);
        return new Response(JSON.stringify({ error }), {
            status: 500,
            headers: {
                "Content-Type": "application/json",
            },
        });
    }
}
