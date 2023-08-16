import { createApp } from "vue";
import App from "@/App.vue";

import router from './router';
import store from './store';

const CONFIG = require("@/config.json");
const API = `${CONFIG.host ? CONFIG.host + '/': ''}api/`;

const TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vaG9tZXN0ZWFkLmdvbGYvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE2ODQzMzExNTksImV4cCI6MTY4NDMzNDc1OSwibmJmIjoxNjg0MzMxMTU5LCJqdGkiOiJlQmVmRkgxR1dyNHpIYkJYIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.l7bxw4wHHARpaAuyZGxH8NvpFl2iqujEzyaC6sjFdAQ"


// Create and setup app
const app = createApp(App);
app.use(router);
app.use(store);
app.mount("#app");

export { API, TOKEN };
