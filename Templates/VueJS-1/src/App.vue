<template>
  <AuthenticatedLayout/>
</template>

<script>
import AuthenticatedLayout from "@/layouts/AuthenticatedLayout.vue";
import UnauthenticatedLayout from "@/layouts/UnauthenticatedLayout.vue";

export default {
  name: "App",
  components: {
      AuthenticatedLayout,
      UnauthenticatedLayout
  }
};
</script>

<style lang="scss">
@use "@/assets/scss/main.scss";
</style>
