<template>
  <div class="list-view">
    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th class="col-icon"></th>
            <th class="col-name">Название</th>
            <th class="col-description">Описание</th>
            <th
              v-for="field in visibleFields"
              :key="field.id"
              class="col-field"
            >
              {{ field.name }}
            </th>
            <th class="col-status">Статус</th>
            <th class="col-actions"></th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="family in families"
            :key="family.id"
            class="table-row"
          >
            <td class="col-icon">
              <span class="family-icon-cell">{{ family.icon }}</span>
            </td>
            <td class="col-name">
              <div class="name-cell">
                <span class="color-dot" :style="{ background: family.color }"></span>
                <span class="name-text">{{ family.name }}</span>
              </div>
            </td>
            <td class="col-description">
              <span class="description-text">{{ family.description || '—' }}</span>
            </td>
            <td
              v-for="field in visibleFields"
              :key="field.id"
              class="col-field"
            >
              <span class="field-value">
                {{ formatFieldValue(field, family.fields[field.id]) }}
              </span>
            </td>
            <td class="col-status">
              <span :class="['status-badge', `status-${family.status}`]">
                {{ statusLabels[family.status] }}
              </span>
            </td>
            <td class="col-actions">
              <div class="action-buttons">
                <button class="btn-icon" @click="$emit('edit', family)">
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <path d="M11.334 2.00004C11.5091 1.82494 11.7169 1.68605 11.9457 1.59129C12.1745 1.49653 12.4197 1.44775 12.6673 1.44775C12.9149 1.44775 13.1601 1.49653 13.3889 1.59129C13.6177 1.68605 13.8256 1.82494 14.0007 2.00004C14.1758 2.17513 14.3147 2.383 14.4094 2.61178C14.5042 2.84055 14.553 3.08575 14.553 3.33337C14.553 3.58099 14.5042 3.82619 14.4094 4.05497C14.3147 4.28374 14.1758 4.49161 14.0007 4.66671L5.00065 13.6667L1.33398 14.6667L2.33398 11L11.334 2.00004Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </button>
                <button class="btn-icon delete-btn" @click="$emit('delete', family)">
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <path d="M2 4H14M12.6667 4V13.3333C12.6667 14 12 14.6667 11.3333 14.6667H4.66667C4 14.6667 3.33333 14 3.33333 13.3333V4M5.33333 4V2.66667C5.33333 2 6 1.33333 6.66667 1.33333H9.33333C10 1.33333 10.6667 2 10.6667 2.66667V4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';

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

const visibleFields = computed(() => {
  return props.fieldDefinitions.slice(0, 4);
});

const statusLabels = {
  active: 'Активна',
  inactive: 'Неактивна',
  archived: 'Архив'
};

const formatFieldValue = (field, value) => {
  if (!value) return '—';

  if (field.field_type === 'date') {
    return new Date(value).toLocaleDateString('ru-RU');
  }

  if (field.field_type === 'multiselect' && Array.isArray(value)) {
    return value.join(', ');
  }

  if (field.field_type === 'number') {
    return new Intl.NumberFormat('ru-RU').format(value);
  }

  return value;
};
</script>

<style scoped>
.list-view {
  width: 100%;
}

.table-container {
  background: var(--color-surface);
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table thead {
  background: var(--color-bg);
  border-bottom: 1px solid var(--color-border);
}

.data-table th {
  padding: 12px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: var(--color-text-secondary);
  white-space: nowrap;
}

.data-table td {
  padding: 16px;
  border-bottom: 1px solid var(--color-border);
}

.table-row {
  transition: var(--transition);
}

.table-row:hover {
  background: var(--color-surface-hover);
}

.table-row:last-child td {
  border-bottom: none;
}

.col-icon {
  width: 60px;
}

.col-name {
  width: 200px;
}

.col-description {
  min-width: 250px;
}

.col-field {
  min-width: 150px;
}

.col-status {
  width: 120px;
}

.col-actions {
  width: 100px;
}

.family-icon-cell {
  font-size: 24px;
}

.name-cell {
  display: flex;
  align-items: center;
  gap: 10px;
}

.color-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
}

.name-text {
  font-weight: 600;
  color: var(--color-text);
}

.description-text {
  color: var(--color-text-secondary);
  font-size: 14px;
  line-height: 1.5;
  display: block;
  max-width: 400px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.field-value {
  color: var(--color-text);
  font-size: 14px;
}

.status-badge {
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
  display: inline-block;
}

.status-active {
  background: rgba(52, 199, 89, 0.1);
  color: #34c759;
}

.status-inactive {
  background: rgba(255, 149, 0, 0.1);
  color: #ff9500;
}

.status-archived {
  background: rgba(142, 142, 147, 0.1);
  color: #8e8e93;
}

.action-buttons {
  display: flex;
  gap: 4px;
  opacity: 0;
  transition: var(--transition);
}

.table-row:hover .action-buttons {
  opacity: 1;
}

.delete-btn:hover {
  color: var(--color-danger);
}
</style>
