<template>
  <div class="kanban-view">
    <div class="kanban-columns">
      <div
        v-for="column in columns"
        :key="column.id"
        class="kanban-column"
      >
        <div class="column-header">
          <div class="column-title">
            <span class="column-badge" :style="{ background: column.color }"></span>
            <span class="column-name">{{ column.name }}</span>
            <span class="column-count">{{ column.accounts.length }}</span>
          </div>
        </div>

        <div class="column-content">
          <TransitionGroup name="card-list" tag="div" class="card-list">
            <AccountCard
              v-for="account in column.accounts"
              :key="account.id"
              :account="account"
              :field-definitions="fieldDefinitions"
              @edit="$emit('edit', account)"
              @delete="$emit('delete', account)"
            />
          </TransitionGroup>

          <div v-if="column.accounts.length === 0" class="empty-state">
            <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
              <rect x="8" y="8" width="32" height="32" rx="4" stroke="currentColor" stroke-width="2" stroke-dasharray="4 4"/>
              <path d="M24 18V30M18 24H30" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
            <p>No accounts yet</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import AccountCard from './AccountCard.vue';

const props = defineProps({
  accounts: {
    type: Array,
    required: true
  },
  statuses: {
    type: Array,
    required: true
  },
  fieldDefinitions: {
    type: Array,
    required: true
  }
});

defineEmits(['edit', 'delete']);

const columns = computed(() => {
  return props.statuses.map(status => ({
    ...status,
    accounts: props.accounts.filter(a => a.status_id === status.id)
  }));
});
</script>

<style scoped>
.kanban-view {
  width: 100%;
  height: 100%;
  overflow-x: auto;
}

.kanban-columns {
  display: flex;
  gap: 24px;
  min-height: calc(100vh - 280px);
  padding-bottom: 24px;
}

.kanban-column {
  flex: 1;
  min-width: 380px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.column-header {
  position: sticky;
  top: 0;
  background: var(--color-bg);
  z-index: 10;
  padding-bottom: 8px;
}

.column-title {
  display: flex;
  align-items: center;
  gap: 12px;
  font-weight: 700;
  font-size: 16px;
  padding: 12px 16px;
  background: var(--color-surface);
  border-radius: var(--radius-md);
  border: 2px solid var(--color-border);
  box-shadow: var(--shadow-sm);
}

.column-badge {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  box-shadow: 0 0 0 3px var(--color-surface);
}

.column-name {
  color: var(--color-text);
  flex: 1;
}

.column-count {
  padding: 4px 12px;
  background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
  border-radius: 12px;
  font-size: 13px;
  font-weight: 700;
  color: white;
  min-width: 32px;
  text-align: center;
}

.column-content {
  flex: 1;
}

.card-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48px 24px;
  background: var(--color-surface);
  border: 2px dashed var(--color-border);
  border-radius: var(--radius-md);
  color: var(--color-text-secondary);
}

.empty-state svg {
  margin-bottom: 12px;
  color: var(--color-text-secondary);
  opacity: 0.5;
}

.empty-state p {
  font-size: 14px;
  font-weight: 500;
}

.card-list-move,
.card-list-enter-active,
.card-list-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.card-list-enter-from {
  opacity: 0;
  transform: translateY(-20px) scale(0.95);
}

.card-list-leave-to {
  opacity: 0;
  transform: translateY(20px) scale(0.95);
}

.card-list-leave-active {
  position: absolute;
  width: 100%;
}
</style>
