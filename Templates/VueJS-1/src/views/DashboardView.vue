<template>
  <HeaderContent :title="`Dashboard`"/>
  <main class="main-content">

  </main>
</template>

<script>
import HeaderContent from "@/components/Header/HeaderContent.vue";
import Icon from "@/components/Icon/Icon.vue";
import {mapGetters} from "vuex";
import router from "@/router";
import TextTile from "@/components/Tile/TextTile.vue";
import ShortcutTile from "@/components/Tile/ShortcutTile.vue";
import NotificationItem from "@/components/Notification/NotificationItem.vue";

export default {
  name: "DashboardView",
  components: {NotificationItem, ShortcutTile, TextTile, Icon, HeaderContent},
  computed: {
    ...mapGetters(['me'])
  },
  methods: {
  }
};
</script>

<style scoped lang="scss">

.main-content {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: repeat(3, 9rem);
  grid-gap: 2.5rem;
  grid-template-areas:
    ". . . ."
    ". bigtile bigtile bigtile"
    ". bigtile bigtile bigtile";

}

</style>
