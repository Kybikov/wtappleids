<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="settings-modal">
      <div class="modal-header">
        <h2 class="modal-title">Settings</h2>
        <button class="btn-icon" @click="$emit('close')">
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <path d="M15 5L5 15M5 5L15 15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
          </svg>
        </button>
      </div>

      <div class="tabs">
        <button
          :class="['tab', { active: activeTab === 'statuses' }]"
          @click="activeTab = 'statuses'"
        >
          Statuses
        </button>
        <button
          :class="['tab', { active: activeTab === 'fields' }]"
          @click="activeTab = 'fields'"
        >
          Fields
        </button>
      </div>

      <div class="modal-body">
        <div v-if="activeTab === 'statuses'" class="settings-section">
          <div class="section-header">
            <h3>Manage Statuses</h3>
            <button class="btn btn-primary btn-sm" @click="showStatusForm = true">
              <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
                <path d="M8 1V15M1 8H15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Add Status
            </button>
          </div>

          <div v-if="showStatusForm" class="form-card">
            <input
              v-model="newStatus.name"
              type="text"
              class="input"
              placeholder="Status name"
            />
            <div class="color-picker">
              <label>Color:</label>
              <div class="color-grid">
                <button
                  v-for="color in statusColors"
                  :key="color"
                  :class="['color-option', { selected: newStatus.color === color }]"
                  :style="{ background: color }"
                  @click="newStatus.color = color"
                ></button>
              </div>
            </div>
            <div class="form-actions">
              <button class="btn btn-secondary btn-sm" @click="cancelStatusForm">Cancel</button>
              <button class="btn btn-primary btn-sm" @click="saveStatus">Save</button>
            </div>
          </div>

          <div class="items-list">
            <div
              v-for="status in statuses"
              :key="status.id"
              class="item-card"
            >
              <div class="item-info">
                <span class="color-dot" :style="{ background: status.color }"></span>
                <span class="item-name">{{ status.name }}</span>
              </div>
              <div class="item-actions">
                <button
                  v-if="!status.is_default"
                  class="btn-icon-sm delete"
                  @click="deleteStatus(status.id)"
                >
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <path d="M2 4H14M12.6667 4V13.3333C12.6667 14 12 14.6667 11.3333 14.6667H4.66667C4 14.6667 3.33333 14 3.33333 13.3333V4M5.33333 4V2.66667C5.33333 2 6 1.33333 6.66667 1.33333H9.33333C10 1.33333 10.6667 2 10.6667 2.66667V4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  </svg>
                </button>
              </div>
            </div>
          </div>
        </div>

        <div v-else-if="activeTab === 'fields'" class="settings-section">
          <div class="section-header">
            <h3>Manage Fields</h3>
            <button class="btn btn-primary btn-sm" @click="showFieldForm = true">
              <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
                <path d="M8 1V15M1 8H15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Add Field
            </button>
          </div>

          <div v-if="showFieldForm" class="form-card">
            <input
              v-model="newField.name"
              type="text"
              class="input"
              placeholder="Field name"
            />
            <select v-model="newField.field_type" class="input">
              <option value="text">Text</option>
              <option value="number">Number</option>
              <option value="email">Email</option>
              <option value="phone">Phone</option>
              <option value="url">URL</option>
              <option value="date">Date</option>
              <option value="checkbox">Checkbox</option>
              <option value="select">Dropdown (Single)</option>
              <option value="multiselect">Dropdown (Multiple)</option>
            </select>

            <div v-if="newField.field_type === 'select' || newField.field_type === 'multiselect'" class="options-input">
              <label>Options (comma separated):</label>
              <input
                v-model="newFieldOptions"
                type="text"
                class="input"
                placeholder="Option 1, Option 2, Option 3"
              />
            </div>

            <div class="form-actions">
              <button class="btn btn-secondary btn-sm" @click="cancelFieldForm">Cancel</button>
              <button class="btn btn-primary btn-sm" @click="saveField">Save</button>
            </div>
          </div>

          <div class="items-list">
            <div
              v-for="field in fieldDefinitions"
              :key="field.id"
              class="item-card"
            >
              <div class="item-info">
                <span class="item-name">{{ field.name }}</span>
                <span class="item-type">{{ formatFieldType(field.field_type) }}</span>
              </div>
              <div class="item-actions">
                <button
                  class="btn-icon-sm delete"
                  @click="deleteField(field.id)"
                >
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <path d="M2 4H14M12.6667 4V13.3333C12.6667 14 12 14.6667 11.3333 14.6667H4.66667C4 14.6667 3.33333 14 3.33333 13.3333V4M5.33333 4V2.66667C5.33333 2 6 1.33333 6.66667 1.33333H9.33333C10 1.33333 10.6667 2 10.6667 2.66667V4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  </svg>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
  statuses: {
    type: Array,
    required: true
  },
  fieldDefinitions: {
    type: Array,
    required: true
  }
});

const emit = defineEmits(['close', 'createStatus', 'deleteStatus', 'createField', 'deleteField']);

const activeTab = ref('statuses');
const showStatusForm = ref(false);
const showFieldForm = ref(false);

const newStatus = ref({
  name: '',
  color: '#10b981',
  position: 0
});

const newField = ref({
  name: '',
  field_type: 'text',
  position: 0
});

const newFieldOptions = ref('');

const statusColors = [
  '#10b981', '#3b82f6', '#8b5cf6', '#ec4899', '#f59e0b', '#ef4444', '#06b6d4', '#6366f1'
];

const cancelStatusForm = () => {
  showStatusForm.value = false;
  newStatus.value = {
    name: '',
    color: '#10b981',
    position: props.statuses.length
  };
};

const saveStatus = async () => {
  if (!newStatus.value.name.trim()) {
    alert('Please enter a status name');
    return;
  }

  newStatus.value.position = props.statuses.length;
  emit('createStatus', { ...newStatus.value });
  cancelStatusForm();
};

const deleteStatus = async (id) => {
  if (confirm('Delete this status? All accounts with this status will be updated.')) {
    emit('deleteStatus', id);
  }
};

const cancelFieldForm = () => {
  showFieldForm.value = false;
  newField.value = {
    name: '',
    field_type: 'text',
    position: 0
  };
  newFieldOptions.value = '';
};

const saveField = async () => {
  if (!newField.value.name.trim()) {
    alert('Please enter a field name');
    return;
  }

  const fieldData = {
    ...newField.value,
    position: props.fieldDefinitions.length
  };

  if (newField.value.field_type === 'select' || newField.value.field_type === 'multiselect') {
    const options = newFieldOptions.value
      .split(',')
      .map(o => o.trim())
      .filter(o => o);
    fieldData.options = options;
  }

  emit('createField', fieldData);
  cancelFieldForm();
};

const deleteField = async (id) => {
  if (confirm('Delete this field? All data for this field will be lost.')) {
    emit('deleteField', id);
  }
};

const formatFieldType = (type) => {
  const types = {
    text: 'Text',
    number: 'Number',
    email: 'Email',
    phone: 'Phone',
    url: 'URL',
    date: 'Date',
    checkbox: 'Checkbox',
    select: 'Dropdown',
    multiselect: 'Multi-select'
  };
  return types[type] || type;
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
  backdrop-filter: blur(4px);
}

.settings-modal {
  background: var(--color-surface);
  border-radius: var(--radius-lg);
  width: 100%;
  max-width: 800px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  box-shadow: var(--shadow-lg);
  animation: modalSlideIn 0.3s ease;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-20px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24px;
  border-bottom: 1px solid var(--color-border);
}

.modal-title {
  font-size: 24px;
  font-weight: 700;
  background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.tabs {
  display: flex;
  gap: 8px;
  padding: 16px 24px 0;
  border-bottom: 2px solid var(--color-border);
}

.tab {
  padding: 12px 24px;
  font-weight: 600;
  color: var(--color-text-secondary);
  border-radius: var(--radius-sm) var(--radius-sm) 0 0;
  transition: var(--transition);
  position: relative;
}

.tab:hover {
  color: var(--color-text);
  background: var(--color-surface-hover);
}

.tab.active {
  color: var(--color-primary);
}

.tab.active::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, var(--color-primary), var(--color-secondary));
  border-radius: 2px;
}

.modal-body {
  flex: 1;
  overflow-y: auto;
  padding: 24px;
}

.settings-section {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.section-header h3 {
  font-size: 18px;
  font-weight: 600;
  color: var(--color-text);
}

.btn-sm {
  padding: 8px 16px;
  font-size: 13px;
}

.form-card {
  background: var(--color-surface-hover);
  border: 2px solid var(--color-border);
  border-radius: var(--radius-md);
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.color-picker {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.color-picker label {
  font-size: 14px;
  font-weight: 500;
  color: var(--color-text);
}

.color-grid {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.color-option {
  width: 40px;
  height: 40px;
  border-radius: var(--radius-sm);
  border: 3px solid transparent;
  transition: var(--transition);
  cursor: pointer;
}

.color-option:hover {
  transform: scale(1.1);
}

.color-option.selected {
  border-color: var(--color-text);
  box-shadow: 0 0 0 2px var(--color-surface), 0 0 0 4px currentColor;
}

.options-input {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.options-input label {
  font-size: 14px;
  font-weight: 500;
  color: var(--color-text);
}

.form-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}

.items-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.item-card {
  background: var(--color-surface);
  border: 2px solid var(--color-border);
  border-radius: var(--radius-md);
  padding: 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  transition: var(--transition);
}

.item-card:hover {
  border-color: var(--color-primary);
  box-shadow: var(--shadow-sm);
}

.item-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.color-dot {
  width: 16px;
  height: 16px;
  border-radius: 50%;
  border: 2px solid var(--color-surface);
  box-shadow: 0 0 0 1px var(--color-border);
}

.item-name {
  font-weight: 600;
  color: var(--color-text);
  font-size: 15px;
}

.item-type {
  padding: 4px 10px;
  background: var(--color-bg);
  border-radius: 8px;
  font-size: 12px;
  font-weight: 500;
  color: var(--color-text-secondary);
}

.item-actions {
  display: flex;
  gap: 8px;
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
}

.btn-icon-sm:hover {
  background: var(--color-surface-hover);
  color: var(--color-text);
}

.btn-icon-sm.delete:hover {
  background: rgba(239, 68, 68, 0.1);
  color: var(--color-danger);
}
</style>
