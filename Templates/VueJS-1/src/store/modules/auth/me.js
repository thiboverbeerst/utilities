import { get } from "@/assets/js/data-connector/api-communication-abstractor";

const state = {
    me: undefined,
};

const getters = {
    me: (state) => state.me,
};

const actions = {
    async fetchMe({ commit }) {
        await get(`auth/me`,(json) => commit('setMe', json.data));
    }
};

const mutations = {
    setMe: (state, user) => (state.me = user)
};

export default {
    state,
    getters,
    actions,
    mutations
};
