<template>
  <nav class="navigation-items-wrapper">
    <ul>
      <li><NavigationItem :route="`/dashboard`" :title="`Dashboard`" :icon="`home`"/></li>
    </ul>
  </nav>
</template>

<script>
import NavigationItem from "@/components/Navigation/NavigationItem";

export default {
  name: "SideNavigation",
  components: {
    NavigationItem
  }
};
</script>
