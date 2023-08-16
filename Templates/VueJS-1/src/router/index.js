import { createRouter, createWebHashHistory } from 'vue-router';

import DashboardView from "@/views/DashboardView";

const routes = [
  {
    path: `/`,
    redirect: `/dashboard`
  },
  {
    path: `/dashboard`,
    name: 'Dashboard',
    component: DashboardView
  }
];

const router = createRouter({
  history: createWebHashHistory(),
  routes
});

export default router;
