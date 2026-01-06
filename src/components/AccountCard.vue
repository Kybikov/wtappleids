<template>
  <div class="account-card card" @click="$emit('edit')">
    <div class="card-header">
      <div class="card-title-section">
        <span class="account-icon">{{ account.icon }}</span>
        <h3 class="account-name">{{ account.name }}</h3>
      </div>
      <div class="card-actions" @click.stop>
        <button class="btn-icon-sm edit-btn" @click="$emit('edit')">
          <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
            <path d="M11.334 2.00004C11.5091 1.82494 11.7169 1.68605 11.9457 1.59129C12.1745 1.49653 12.4197 1.44775 12.6673 1.44775C12.9149 1.44775 13.1601 1.49653 13.3889 1.59129C13.6177 1.68605 13.8256 1.82494 14.0007 2.00004C14.1758 2.17513 14.3147 2.383 14.4094 2.61178C14.5042 2.84055 14.553 3.08575 14.553 3.33337C14.553 3.58099 14.5042 3.82619 14.4094 4.05497C14.3147 4.28374 14.1758 4.49161 14.0007 4.66671L5.00065 13.6667L1.33398 14.6667L2.33398 11L11.334 2.00004Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>
        <button class="btn-icon-sm delete-btn" @click="$emit('delete')">
          <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
            <path d="M2 4H14M12.6667 4V13.3333C12.6667 14 12 14.6667 11.3333 14.6667H4.66667C4 14.6667 3.33333 14 3.33333 13.3333V4M5.33333 4V2.66667C5.33333 2 6 1.33333 6.66667 1.33333H9.33333C10 1.33333 10.6667 2 10.6667 2.66667V4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>
      </div>
    </div>

    <p v-if="account.description" class="account-description">
      {{ account.description }}
    </p>

    <div class="account-fields">
      <div
        v-for="field in visibleFields"
        :key="field.id"
        class="field-item"
      >
        <span class="field-label">{{ field.name }}</span>
        <span class="field-value">{{ formatFieldValue(field, account.fields[field.id]) }}</span>
      </div>
    </div>

    <div class="card-footer">
      <div class="footer-left">
        <span class="color-indicator" :style="{ background: account.color }"></span>
        <span class="status-badge" :style="{ background: account.statuses?.color + '20', color: account.statuses?.color }">
          {{ account.statuses?.name || 'No Status' }}
        </span>
      </div>
      <span class="date-label">{{ formatDate(account.created_at) }}</span>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  account: {
    type: Object,
    required: true
  },
  fieldDefinitions: {
    type: Array,
    required: true
  }
});

defineEmits(['edit', 'delete']);

const visibleFields = computed(() => {
  return props.fieldDefinitions.slice(0, 3);
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

const formatDate = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric'
  });
};
</script>

<style scoped>
.account-card {
  padding: 20px;
  cursor: pointer;
  transition: var(--transition);
  border: 2px solid var(--color-border);
  position: relative;
  overflow: hidden;
}

.account-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--color-primary), var(--color-secondary));
  transform: scaleX(0);
  transition: var(--transition);
}

.account-card:hover::before {
  transform: scaleX(1);
}

.account-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
  border-color: var(--color-primary);
}

.card-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.card-title-section {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
}

.account-icon {
  font-size: 28px;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.account-name {
  font-size: 17px;
  font-weight: 700;
  color: var(--color-text);
  line-height: 1.3;
}

.card-actions {
  display: flex;
  gap: 6px;
  opacity: 0;
  transition: var(--transition);
}

.account-card:hover .card-actions {
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
  color: var(--color-text);
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

.account-description {
  color: var(--color-text-secondary);
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 14px;
}

.account-fields {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 14px;
}

.field-item {
  display: flex;
  justify-content: space-between;
  align-items: start;
  gap: 12px;
  font-size: 13px;
}

.field-label {
  color: var(--color-text-secondary);
  font-weight: 600;
  min-width: 90px;
}

.field-value {
  color: var(--color-text);
  flex: 1;
  text-align: right;
  font-weight: 500;
}

.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 14px;
  border-top: 2px solid var(--color-border);
  margin-top: auto;
}

.footer-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.color-indicator {
  width: 24px;
  height: 24px;
  border-radius: 6px;
  border: 2px solid var(--color-surface);
  box-shadow: 0 0 0 1px var(--color-border);
}

.status-badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
}

.date-label {
  font-size: 12px;
  font-weight: 500;
  color: var(--color-text-secondary);
}
</style>
