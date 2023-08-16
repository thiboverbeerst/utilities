import { createStore } from "vuex";

// modules
import me from "@/store/modules/auth/me";

import notification from "@/store/modules/notification";


const store = createStore({
    modules: {
        me,
        notification
    }
});

export default store;
