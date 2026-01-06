<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-container">
      <div class="modal-header">
        <h2 class="modal-title">
          {{ account ? 'Edit Account' : 'New Apple Account' }}
        </h2>
        <button class="btn-icon-close" @click="$emit('close')">
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <path d="M15 5L5 15M5 5L15 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"/>
          </svg>
        </button>
      </div>

      <div class="modal-body">
        <div class="form-section">
          <h3 class="section-title">Basic Information</h3>

          <div class="form-grid">
            <div class="form-group full-width">
              <label class="form-label">Account Name *</label>
              <input
                v-model="formData.name"
                type="text"
                class="input"
                placeholder="e.g., John's Apple ID"
                required
              />
            </div>

            <div class="form-group full-width">
              <label class="form-label">Description</label>
              <textarea
                v-model="formData.description"
                class="input textarea"
                placeholder="Brief description about this account"
                rows="3"
              ></textarea>
            </div>

            <div class="form-group">
              <label class="form-label">Icon</label>
              <div class="icon-selector">
                <button
                  v-for="icon in icons"
                  :key="icon"
                  type="button"
                  :class="['icon-btn', { selected: formData.icon === icon }]"
                  @click="formData.icon = icon"
                >
                  {{ icon }}
                </button>
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">Color</label>
              <div class="color-selector">
                <button
                  v-for="color in colors"
                  :key="color"
                  type="button"
                  :class="['color-btn', { selected: formData.color === color }]"
                  :style="{ background: color }"
                  @click="formData.color = color"
                ></button>
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">Status</label>
              <select v-model="formData.status_id" class="input">
                <option value="">Select status</option>
                <option
                  v-for="status in statuses"
                  :key="status.id"
                  :value="status.id"
                >
                  {{ status.name }}
                </option>
              </select>
            </div>
          </div>
        </div>

        <div class="form-section">
          <h3 class="section-title">Additional Fields</h3>

          <div class="fields-grid">
            <div
              v-for="field in fieldDefinitions"
              :key="field.id"
              :class="['field-group', { 'full-width': field.field_type === 'text' || field.field_type === 'multiselect' }]"
            >
              <label class="form-label">{{ field.name }}</label>

              <input
                v-if="field.field_type === 'text'"
                v-model="formData.fields[field.id]"
                type="text"
                class="input"
                :placeholder="`Enter ${field.name.toLowerCase()}`"
              />

              <input
                v-else-if="field.field_type === 'email'"
                v-model="formData.fields[field.id]"
                type="email"
                class="input"
                :placeholder="`Enter ${field.name.toLowerCase()}`"
              />

              <input
                v-else-if="field.field_type === 'phone'"
                v-model="formData.fields[field.id]"
                type="tel"
                class="input"
                :placeholder="`Enter ${field.name.toLowerCase()}`"
              />

              <input
                v-else-if="field.field_type === 'url'"
                v-model="formData.fields[field.id]"
                type="url"
                class="input"
                :placeholder="`Enter ${field.name.toLowerCase()}`"
              />

              <input
                v-else-if="field.field_type === 'number'"
                v-model.number="formData.fields[field.id]"
                type="number"
                class="input"
                :placeholder="`Enter ${field.name.toLowerCase()}`"
              />

              <input
                v-else-if="field.field_type === 'date'"
                v-model="formData.fields[field.id]"
                type="date"
                class="input"
              />

              <select
                v-else-if="field.field_type === 'select'"
                v-model="formData.fields[field.id]"
                class="input"
              >
                <option value="">Select value</option>
                <option
                  v-for="option in field.options"
                  :key="option"
                  :value="option"
                >
                  {{ option }}
                </option>
              </select>

              <div
                v-else-if="field.field_type === 'multiselect'"
                class="multiselect"
              >
                <label
                  v-for="option in field.options"
                  :key="option"
                  class="checkbox-label"
                >
                  <input
                    type="checkbox"
                    :value="option"
                    :checked="formData.fields[field.id]?.includes(option)"
                    @change="toggleMultiselect(field.id, option)"
                  />
                  <span>{{ option }}</span>
                </label>
              </div>

              <label
                v-else-if="field.field_type === 'checkbox'"
                class="checkbox-label standalone"
              >
                <input
                  v-model="formData.fields[field.id]"
                  type="checkbox"
                />
                <span>Enabled</span>
              </label>
            </div>
          </div>
        </div>
      </div>

      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')">
          Cancel
        </button>
        <button class="btn btn-primary" @click="handleSave">
          <svg v-if="!account" width="16" height="16" viewBox="0 0 16 16" fill="none">
            <path d="M8 1V15M1 8H15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
          </svg>
          {{ account ? 'Save Changes' : 'Create Account' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue';
import { useAccounts } from '../composables/useAccounts';

const props = defineProps({
  account: {
    type: Object,
    default: null
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

const emit = defineEmits(['close', 'save']);

const { updateFieldValue } = useAccounts();

const icons = ['🍎', '👤', '👨', '👩', '👨‍💼', '👩‍💼', '👶', '🧑', '💼', '🎓'];
const colors = [
  '#10b981', '#3b82f6', '#8b5cf6', '#ec4899',
  '#f59e0b', '#ef4444', '#06b6d4', '#6366f1',
  '#14b8a6', '#f97316', '#84cc16', '#a855f7'
];

const formData = reactive({
  name: '',
  description: '',
  icon: '🍎',
  color: '#10b981',
  status_id: '',
  position: 0,
  fields: {}
});

watch(() => props.account, (newAccount) => {
  if (newAccount) {
    Object.assign(formData, {
      name: newAccount.name,
      description: newAccount.description,
      icon: newAccount.icon,
      color: newAccount.color,
      status_id: newAccount.status_id || '',
      position: newAccount.position,
      fields: { ...newAccount.fields }
    });
  } else {
    formData.status_id = props.statuses[0]?.id || '';
  }
}, { immediate: true });

const toggleMultiselect = (fieldId, option) => {
  if (!formData.fields[fieldId]) {
    formData.fields[fieldId] = [];
  }

  const index = formData.fields[fieldId].indexOf(option);
  if (index > -1) {
    formData.fields[fieldId].splice(index, 1);
  } else {
    formData.fields[fieldId].push(option);
  }
};

const handleSave = async () => {
  if (!formData.name.trim()) {
    alert('Please enter an account name');
    return;
  }

  if (!formData.status_id) {
    alert('Please select a status');
    return;
  }

  const accountData = {
    name: formData.name,
    description: formData.description,
    icon: formData.icon,
    color: formData.color,
    status_id: formData.status_id,
    position: formData.position
  };

  emit('save', accountData);

  if (props.account) {
    for (const [fieldId, value] of Object.entries(formData.fields)) {
      if (value !== null && value !== undefined && value !== '') {
        await updateFieldValue(props.account.id, fieldId, value);
      }
    }
  }
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
  backdrop-filter: blur(8px);
  animation: fadeIn 0.2s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.modal-container {
  background: var(--color-surface);
  border-radius: var(--radius-lg);
  width: 100%;
  max-width: 800px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  box-shadow: var(--shadow-lg);
  animation: modalSlideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 2px solid var(--color-border);
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-30px) scale(0.95);
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
  padding: 28px 32px;
  border-bottom: 2px solid var(--color-border);
  background: linear-gradient(135deg, #ffffff 0%, #fff5f7 100%);
}

.modal-title {
  font-size: 26px;
  font-weight: 700;
  background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.btn-icon-close {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 10px;
  color: var(--color-text-secondary);
  transition: var(--transition);
  background: var(--color-surface);
  border: 2px solid var(--color-border);
}

.btn-icon-close:hover {
  border-color: var(--color-danger);
  color: var(--color-danger);
  transform: rotate(90deg);
}

.modal-body {
  flex: 1;
  overflow-y: auto;
  padding: 32px;
}

.form-section {
  margin-bottom: 36px;
}

.form-section:last-child {
  margin-bottom: 0;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--color-text);
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 2px solid var(--color-border);
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.form-group.full-width {
  grid-column: 1 / -1;
}

.form-label {
  font-size: 14px;
  font-weight: 600;
  color: var(--color-text);
}

.textarea {
  resize: vertical;
  min-height: 90px;
  font-family: inherit;
  padding: 12px 16px;
  line-height: 1.6;
}

.icon-selector {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.icon-btn {
  width: 52px;
  height: 52px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26px;
  border-radius: var(--radius-sm);
  border: 2px solid var(--color-border);
  background: var(--color-surface);
  transition: var(--transition);
}

.icon-btn:hover {
  border-color: var(--color-primary);
  transform: scale(1.1);
  box-shadow: var(--shadow-sm);
}

.icon-btn.selected {
  border-color: var(--color-primary);
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(236, 72, 153, 0.1));
  box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
}

.color-selector {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.color-btn {
  width: 44px;
  height: 44px;
  border-radius: var(--radius-sm);
  border: 3px solid transparent;
  transition: var(--transition);
  position: relative;
}

.color-btn:hover {
  transform: scale(1.15);
  box-shadow: var(--shadow-md);
}

.color-btn.selected {
  border-color: var(--color-text);
  box-shadow: 0 0 0 2px var(--color-surface), 0 0 0 5px currentColor;
}

.fields-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.field-group {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.field-group.full-width {
  grid-column: 1 / -1;
}

.multiselect {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 16px;
  background: var(--color-bg);
  border-radius: var(--radius-sm);
  border: 2px solid var(--color-border);
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  font-weight: 500;
  color: var(--color-text);
  cursor: pointer;
  padding: 6px;
  border-radius: 8px;
  transition: var(--transition);
}

.checkbox-label:hover {
  background: var(--color-surface);
}

.checkbox-label input[type="checkbox"] {
  width: 20px;
  height: 20px;
  cursor: pointer;
  accent-color: var(--color-primary);
}

.checkbox-label.standalone {
  background: var(--color-bg);
  border: 2px solid var(--color-border);
  padding: 12px 16px;
  border-radius: var(--radius-sm);
}

.modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 14px;
  padding: 24px 32px;
  border-top: 2px solid var(--color-border);
  background: linear-gradient(135deg, #ffffff 0%, #fff5f7 100%);
}

.btn {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
}
</style>
