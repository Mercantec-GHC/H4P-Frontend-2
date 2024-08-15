import { createUser } from "@/app/actions/createUser";
export const revalidate = 0;

export async function POST(req) {
    //Get body from request
    try {
        console.log(req);
        const formData = await req.formData();

        let username = formData.get("username");
        let password = formData.get("password");

        let res = await createUser({ username, password }).then((data) => {
            console.log(data);
            return data;
        });
        return Response.json({ res });
    } catch (error) {
        console.log(error);
        return Response.error({ error });
    }
}
