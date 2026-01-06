<template>
  <div class="family-card card">
    <div class="card-header">
      <div class="card-title-section">
        <span class="family-icon">{{ family.icon }}</span>
        <h3 class="family-name">{{ family.name }}</h3>
      </div>
      <div class="card-actions">
        <button class="btn-icon" @click="$emit('edit')">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
            <path d="M11.334 2.00004C11.5091 1.82494 11.7169 1.68605 11.9457 1.59129C12.1745 1.49653 12.4197 1.44775 12.6673 1.44775C12.9149 1.44775 13.1601 1.49653 13.3889 1.59129C13.6177 1.68605 13.8256 1.82494 14.0007 2.00004C14.1758 2.17513 14.3147 2.383 14.4094 2.61178C14.5042 2.84055 14.553 3.08575 14.553 3.33337C14.553 3.58099 14.5042 3.82619 14.4094 4.05497C14.3147 4.28374 14.1758 4.49161 14.0007 4.66671L5.00065 13.6667L1.33398 14.6667L2.33398 11L11.334 2.00004Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>
        <button class="btn-icon delete-btn" @click="$emit('delete')">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
            <path d="M2 4H14M12.6667 4V13.3333C12.6667 14 12 14.6667 11.3333 14.6667H4.66667C4 14.6667 3.33333 14 3.33333 13.3333V4M5.33333 4V2.66667C5.33333 2 6 1.33333 6.66667 1.33333H9.33333C10 1.33333 10.6667 2 10.6667 2.66667V4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>
      </div>
    </div>

    <p v-if="family.description" class="family-description">
      {{ family.description }}
    </p>

    <div class="family-fields">
      <div
        v-for="field in visibleFields"
        :key="field.id"
        class="field-item"
      >
        <span class="field-label">{{ field.name }}:</span>
        <span class="field-value">{{ formatFieldValue(field, family.fields[field.id]) }}</span>
      </div>
    </div>

    <div class="card-footer">
      <span class="color-indicator" :style="{ background: family.color }"></span>
      <span class="date-label">{{ formatDate(family.created_at) }}</span>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  family: {
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
  return props.fieldDefinitions.slice(0, 4);
});

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

const formatDate = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('ru-RU', {
    day: 'numeric',
    month: 'short'
  });
};
</script>

<style scoped>
.family-card {
  padding: 16px;
  cursor: pointer;
  transition: var(--transition);
}

.family-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
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
  gap: 10px;
  flex: 1;
}

.family-icon {
  font-size: 24px;
}

.family-name {
  font-size: 16px;
  font-weight: 600;
  color: var(--color-text);
  line-height: 1.3;
}

.card-actions {
  display: flex;
  gap: 4px;
  opacity: 0;
  transition: var(--transition);
}

.family-card:hover .card-actions {
  opacity: 1;
}

.delete-btn:hover {
  color: var(--color-danger);
}

.family-description {
  color: var(--color-text-secondary);
  font-size: 14px;
  line-height: 1.5;
  margin-bottom: 12px;
}

.family-fields {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 12px;
}

.field-item {
  display: flex;
  gap: 8px;
  font-size: 13px;
}

.field-label {
  color: var(--color-text-secondary);
  font-weight: 500;
  min-width: 100px;
}

.field-value {
  color: var(--color-text);
  flex: 1;
}

.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 12px;
  border-top: 1px solid var(--color-border);
}

.color-indicator {
  width: 20px;
  height: 20px;
  border-radius: 4px;
  border: 2px solid var(--color-surface);
  box-shadow: 0 0 0 1px var(--color-border);
}

.date-label {
  font-size: 12px;
  color: var(--color-text-secondary);
}
</style>
