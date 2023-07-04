import axios from "axios";

const authenticateRequest = async (request, url, body) => {
    try {
        const token = window.localStorage.getItem("token");
        const header = {
            headers: {
                authorization: token,
            },
        };

        if (token) {
            if (request === "get") {
                const { data } = await axios.get(url, header);
                return data;
            } else if (request === "post") {
                const { data } = await axios.post(url, body, header);
                return data;
            } else if (request === "delete") {
                const res = await axios.delete(url, header);
                return res;
            } else if (request === "put") {
                const { data } = await axios.put(url, body, header);
                return data;
            }
        }
    } catch (error) {
        console.log(error);
    }
};

export { authenticateRequest };
