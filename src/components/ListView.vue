<template>
  <div class="list-view">
    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th class="col-icon"></th>
            <th class="col-name">Name</th>
            <th class="col-description">Description</th>
            <th
              v-for="field in visibleFields"
              :key="field.id"
              class="col-field"
            >
              {{ field.name }}
            </th>
            <th class="col-status">Status</th>
            <th class="col-actions"></th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="account in accounts"
            :key="account.id"
            class="table-row"
          >
            <td class="col-icon">
              <span class="account-icon-cell">{{ account.icon }}</span>
            </td>
            <td class="col-name">
              <div class="name-cell">
                <span class="color-dot" :style="{ background: account.color }"></span>
                <span class="name-text">{{ account.name }}</span>
              </div>
            </td>
            <td class="col-description">
              <span class="description-text">{{ account.description || '—' }}</span>
            </td>
            <td
              v-for="field in visibleFields"
              :key="field.id"
              class="col-field"
            >
              <span class="field-value">
                {{ formatFieldValue(field, account.fields[field.id]) }}
              </span>
            </td>
            <td class="col-status">
              <span
                class="status-badge"
                :style="{
                  background: account.statuses?.color + '20',
                  color: account.statuses?.color,
                  borderColor: account.statuses?.color
                }"
              >
                {{ account.statuses?.name || 'No Status' }}
              </span>
            </td>
            <td class="col-actions">
              <div class="action-buttons">
                <button class="btn-icon-sm edit-btn" @click="$emit('edit', account)">
                  <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
                    <path d="M11.334 2.00004C11.5091 1.82494 11.7169 1.68605 11.9457 1.59129C12.1745 1.49653 12.4197 1.44775 12.6673 1.44775C12.9149 1.44775 13.1601 1.49653 13.3889 1.59129C13.6177 1.68605 13.8256 1.82494 14.0007 2.00004C14.1758 2.17513 14.3147 2.383 14.4094 2.61178C14.5042 2.84055 14.553 3.08575 14.553 3.33337C14.553 3.58099 14.5042 3.82619 14.4094 4.05497C14.3147 4.28374 14.1758 4.49161 14.0007 4.66671L5.00065 13.6667L1.33398 14.6667L2.33398 11L11.334 2.00004Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </button>
                <button class="btn-icon-sm delete-btn" @click="$emit('delete', account)">
                  <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
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

const visibleFields = computed(() => {
  return props.fieldDefinitions.slice(0, 4);
});

const formatFieldValue = (field, value) => {
  if (!value || value === null || value === 'null') return '—';

  if (field.field_type === 'date') {
    return new Date(value).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric'
    });
  }

  if (field.field_type === 'multiselect' && Array.isArray(value)) {
    return value.join(', ');
  }

  if (field.field_type === 'number') {
    return new Intl.NumberFormat('en-US').format(value);
  }

  if (field.field_type === 'checkbox') {
    return value ? 'Yes' : 'No';
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
  border: 2px solid var(--color-border);
  overflow: hidden;
  box-shadow: var(--shadow-md);
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table thead {
  background: linear-gradient(135deg, #ffffff 0%, #fff5f7 100%);
  border-bottom: 2px solid var(--color-border);
}

.data-table th {
  padding: 16px 20px;
  text-align: left;
  font-size: 13px;
  font-weight: 700;
  color: var(--color-text);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  white-space: nowrap;
}

.data-table td {
  padding: 18px 20px;
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
  width: 70px;
}

.col-name {
  width: 220px;
}

.col-description {
  min-width: 280px;
}

.col-field {
  min-width: 160px;
}

.col-status {
  width: 140px;
}

.col-actions {
  width: 100px;
}

.account-icon-cell {
  font-size: 28px;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.name-cell {
  display: flex;
  align-items: center;
  gap: 12px;
}

.color-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  flex-shrink: 0;
  box-shadow: 0 0 0 3px var(--color-surface);
}

.name-text {
  font-weight: 700;
  color: var(--color-text);
  font-size: 15px;
}

.description-text {
  color: var(--color-text-secondary);
  font-size: 14px;
  line-height: 1.5;
  display: block;
  max-width: 500px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.field-value {
  color: var(--color-text);
  font-size: 14px;
  font-weight: 500;
}

.status-badge {
  padding: 6px 14px;
  border-radius: 14px;
  font-size: 12px;
  font-weight: 700;
  display: inline-block;
  border: 2px solid;
}

.action-buttons {
  display: flex;
  gap: 6px;
  opacity: 0;
  transition: var(--transition);
}

.table-row:hover .action-buttons {
  opacity: 1;
}

.btn-icon-sm {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  color: var(--color-text-secondary);
  transition: var(--transition);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
}

.btn-icon-sm:hover {
  background: var(--color-surface-hover);
  transform: scale(1.1);
}

.edit-btn:hover {
  background: rgba(16, 185, 129, 0.1);
  color: var(--color-primary);
  border-color: var(--color-primary);
}

.delete-btn:hover {
  background: rgba(239, 68, 68, 0.1);
  color: var(--color-danger);
  border-color: var(--color-danger);
}
</style>
