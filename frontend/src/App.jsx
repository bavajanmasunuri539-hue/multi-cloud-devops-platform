import { useEffect, useState } from "react";

function App() {
    const [backendStatus, setBackendStatus] = useState("Checking...");
    const [apiStatus, setApiStatus] = useState("Checking...");

    useEffect(() => {
        fetch("/backend/health")
            .then((response) => response.json())
            .then((data) => {
                setBackendStatus(data.status);
            })
            .catch(() => {
                setBackendStatus("Unavailable");
            });

        fetch("/api-service/health")
            .then((response) => response.json())
            .then((data) => {
                setApiStatus(data.status);
            })
            .catch(() => {
                setApiStatus("Unavailable");
            });
    }, []);

    return (
        <div>
            <h1>Multi-Cloud DevOps Platform</h1>

            <p>
                React frontend running with Nginx
            </p>

            <hr />

            <h2>Services</h2>

            <p>
                Backend:
                <strong> {backendStatus}</strong>
            </p>

            <p>
                API:
                <strong> {apiStatus}</strong>
            </p>
        </div>
    );
}

export default App;