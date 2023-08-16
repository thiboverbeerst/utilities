<template>
  <div class="error-wrapper flex-center-col">
    <TypeWriter :values="messages"/>
  </div>
</template>

<script>
import TypeWriter from "@/components/Util/TypeWriter";
import TextButton from "@/components/Button/TextButton";

export default {
  name: "ErrorWriter",
  components: {
    TypeWriter,
    TextButton
  },
  props: {
    messages: Array
  }
};
</script>

<style scoped>

.error-wrapper {
  height: 100vh;
  width: 100vw;
}

</style>
