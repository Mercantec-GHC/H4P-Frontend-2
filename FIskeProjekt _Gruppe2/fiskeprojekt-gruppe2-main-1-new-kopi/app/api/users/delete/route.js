import { deleteUser } from "../../../actions/deleteUser"; // Ensure this path is correct based on your project structure
export const revalidate = 0;

export async function DELETE(req) {
    try {
        // Assuming the username is being sent in the request body
        const formData = await req.formData();
        let username = formData.get("username");

        // If you are using JSON data instead of form data:
        //const { username } = await req.json();

        let res = await deleteUser({ username }).then((data) => {
            console.log(data);
            return data;
        });

        if (res.status === 200) {
            return new Response(JSON.stringify({ message: "User deleted successfully" }), {
                status: 200,
            });
        } else if (res.status === 404) {
            return new Response(JSON.stringify({ message: "User not found" }), {
                status: 404,
            });
        } else {
            return new Response(JSON.stringify({ message: "Error deleting user" }), {
                status: 500,
            });
        }
    } catch (error) {
        console.log(error);
        return new Response(JSON.stringify({ error: "Internal Server Error" }), {
            status: 500,
        });
    }
}