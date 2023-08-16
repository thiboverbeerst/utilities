<template>
  <LoadApp v-if="!loaded"/>
  <div id="authenticated-layout" v-if="loaded">
    <div class="sidebar-wrapper">
      <Sidebar/>
    </div>
    <div class="header-and-content-wrapper">
      <HeaderBar/>
      <NotificationBar v-show="notificationShow"/>
      <section class="content-wrapper">
        <router-view/>
      </section>
    </div>
  </div>
</template>

<script>
import {mapActions, mapGetters} from "vuex";

import LoadApp from "@/components/Load/LoadApp";
import Sidebar from "@/components/Sidebar/Sidebar";
import HeaderBar from "@/components/Header/HeaderBar";
import NotificationBar from "@/components/Notification/NotificationBar";


export default {
  name: "AuthenticatedLayout",
  components: {
    LoadApp,
    Sidebar,
    HeaderBar,
    NotificationBar
  },
  data() {
    return {
      loaded: false,
      reloadTimer: undefined
    };
  },
  computed: {
    ...mapGetters(['notificationShow', 'me'])
  },
  async mounted() {

      await this.fetchMe().then(() => {
          this.loaded = true;
          this.reload();
          this.createNotification({content: `Welcome, ${this.me.first_name} ${this.me.last_name}!`});
      });

  },
  methods: {
    ...mapActions(["fetchMe", "createNotification"]),
    reload() {
      this.fetchMe();
      // Pre-load data here
      this.reloadTimer = setTimeout(this.reload, 2000);
    }
  },
  destroyed() {
    clearTimeout(this.reloadTimer);
  }
};
</script>

<style scoped lang="scss">


#authenticated-layout {
  --sidebar-width: 16rem;

  position: fixed;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}

.sidebar-wrapper {
  @include pos-fixed-top-left();
  overflow: hidden;
  height: 100vh;
  width: var(--sidebar-width);
}

.header-and-content-wrapper {
  position: relative;
  height: 100vh;
  margin-left: var(--sidebar-width);
}

.content-wrapper {
  /* 5rem from padding and 4rem is from header bar */
  height: calc(100vh - 5rem - 4rem);
  background-color: var(--color-background-mute);
  padding: 2.5rem;
  overflow: auto;
}

</style>
