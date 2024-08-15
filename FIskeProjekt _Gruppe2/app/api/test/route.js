import { getData } from "@/app/actions/neondb";
export const revaidate = 0;

export async function GET() {
    const data = await getData().then((data) => {
        console.log(data);
        return data;
    });

    const connected = data.length > 0;

    return Response.json("API IS ONLINE, CONNECTED TO DATABASE: " + connected);
}
