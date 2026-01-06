<template>
  <div class="kanban-view">
    <div class="kanban-columns">
      <div
        v-for="column in columns"
        :key="column.value"
        class="kanban-column"
      >
        <div class="column-header">
          <div class="column-title">
            <span class="column-badge" :style="{ background: column.color }"></span>
            <span class="column-name">{{ column.label }}</span>
            <span class="column-count">{{ column.families.length }}</span>
          </div>
        </div>

        <div class="column-content">
          <TransitionGroup name="card-list" tag="div" class="card-list">
            <FamilyCard
              v-for="family in column.families"
              :key="family.id"
              :family="family"
              :field-definitions="fieldDefinitions"
              @edit="$emit('edit', family)"
              @delete="$emit('delete', family)"
            />
          </TransitionGroup>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import FamilyCard from './FamilyCard.vue';

const props = defineProps({
  families: {
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
  const statusColumns = [
    {
      value: 'active',
      label: 'Активные',
      color: '#34c759'
    },
    {
      value: 'inactive',
      label: 'Неактивные',
      color: '#ff9500'
    },
    {
      value: 'archived',
      label: 'Архив',
      color: '#8e8e93'
    }
  ];

  return statusColumns.map(col => ({
    ...col,
    families: props.families.filter(f => f.status === col.value)
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
  min-height: calc(100vh - 220px);
  padding-bottom: 24px;
}

.kanban-column {
  flex: 1;
  min-width: 350px;
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
  gap: 10px;
  font-weight: 600;
  font-size: 15px;
}

.column-badge {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}

.column-name {
  color: var(--color-text);
}

.column-count {
  padding: 2px 8px;
  background: var(--color-surface);
  border-radius: 10px;
  font-size: 12px;
  font-weight: 500;
  color: var(--color-text-secondary);
  border: 1px solid var(--color-border);
}

.column-content {
  flex: 1;
}

.card-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.card-list-move,
.card-list-enter-active,
.card-list-leave-active {
  transition: all 0.3s ease;
}

.card-list-enter-from {
  opacity: 0;
  transform: translateY(-20px);
}

.card-list-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

.card-list-leave-active {
  position: absolute;
}
</style>
