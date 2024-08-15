import { getData } from "./actions/neondb";

export default async function Page() {
    let data = await getData().then((data) => {
        console.log(data);
        return data;
    });
    return (
        <div>
            <h1>My Users</h1>
            <ul>
                {data.map((user) => (
                    <li key={user.id}>
                        <div>
                            <h2>{user.username}</h2>
                            <p>{user.password}</p>
                        </div>
                    </li>
                ))}
            </ul>
        </div>
    );
}
