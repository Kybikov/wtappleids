<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-container">
      <div class="modal-header">
        <h2 class="modal-title">
          {{ family ? 'Редактировать семью' : 'Новая семья' }}
        </h2>
        <button class="btn-icon" @click="$emit('close')">
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <path d="M15 5L5 15M5 5L15 15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
          </svg>
        </button>
      </div>

      <div class="modal-body">
        <div class="form-section">
          <h3 class="section-title">Основная информация</h3>

          <div class="form-grid">
            <div class="form-group full-width">
              <label class="form-label">Название семьи</label>
              <input
                v-model="formData.name"
                type="text"
                class="input"
                placeholder="Введите название"
                required
              />
            </div>

            <div class="form-group full-width">
              <label class="form-label">Описание</label>
              <textarea
                v-model="formData.description"
                class="input textarea"
                placeholder="Краткое описание семьи"
                rows="3"
              ></textarea>
            </div>

            <div class="form-group">
              <label class="form-label">Иконка</label>
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
              <label class="form-label">Цвет</label>
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
              <label class="form-label">Статус</label>
              <select v-model="formData.status" class="input">
                <option value="active">Активна</option>
                <option value="inactive">Неактивна</option>
                <option value="archived">Архив</option>
              </select>
            </div>
          </div>
        </div>

        <div class="form-section">
          <h3 class="section-title">Дополнительные поля</h3>

          <div class="fields-list">
            <div
              v-for="field in fieldDefinitions"
              :key="field.id"
              class="field-group"
            >
              <label class="form-label">{{ field.name }}</label>

              <input
                v-if="field.field_type === 'text' || field.field_type === 'email' || field.field_type === 'phone' || field.field_type === 'url'"
                v-model="formData.fields[field.id]"
                :type="field.field_type === 'text' ? 'text' : field.field_type"
                class="input"
                :placeholder="`Введите ${field.name.toLowerCase()}`"
              />

              <input
                v-else-if="field.field_type === 'number'"
                v-model.number="formData.fields[field.id]"
                type="number"
                class="input"
                :placeholder="`Введите ${field.name.toLowerCase()}`"
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
                <option value="">Выберите значение</option>
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
                class="checkbox-label"
              >
                <input
                  v-model="formData.fields[field.id]"
                  type="checkbox"
                />
                <span>Включено</span>
              </label>
            </div>
          </div>
        </div>
      </div>

      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')">
          Отмена
        </button>
        <button class="btn btn-primary" @click="handleSave">
          {{ family ? 'Сохранить' : 'Создать' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue';
import { useFamilies } from '../composables/useFamilies';

const props = defineProps({
  family: {
    type: Object,
    default: null
  },
  fieldDefinitions: {
    type: Array,
    required: true
  }
});

const emit = defineEmits(['close', 'save']);

const { updateFieldValue } = useFamilies();

const icons = ['👨‍👩‍👧‍👦', '👨‍👩‍👧', '👨‍👩‍👦‍👦', '👨‍👩‍👦', '👩‍👩‍👧', '👨‍👨‍👦', '🏠', '💼'];
const colors = ['#0071e3', '#34c759', '#ff9500', '#ff3b30', '#5856d6', '#ff2d55', '#64d2ff', '#30b0c7'];

const formData = reactive({
  name: '',
  description: '',
  icon: '👨‍👩‍👧‍👦',
  color: '#0071e3',
  status: 'active',
  position: 0,
  fields: {}
});

watch(() => props.family, (newFamily) => {
  if (newFamily) {
    Object.assign(formData, {
      name: newFamily.name,
      description: newFamily.description,
      icon: newFamily.icon,
      color: newFamily.color,
      status: newFamily.status,
      position: newFamily.position,
      fields: { ...newFamily.fields }
    });
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
    alert('Пожалуйста, введите название семьи');
    return;
  }

  const familyData = {
    name: formData.name,
    description: formData.description,
    icon: formData.icon,
    color: formData.color,
    status: formData.status,
    position: formData.position
  };

  emit('save', familyData);

  if (props.family) {
    for (const [fieldId, value] of Object.entries(formData.fields)) {
      if (value !== null && value !== undefined && value !== '') {
        await updateFieldValue(props.family.id, fieldId, value);
      }
    }
  }
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

.modal-container {
  background: var(--color-surface);
  border-radius: var(--radius-lg);
  width: 100%;
  max-width: 700px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  box-shadow: var(--shadow-lg);
  animation: modalSlideIn 0.3s ease;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
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
  font-size: 20px;
  font-weight: 600;
  color: var(--color-text);
}

.modal-body {
  flex: 1;
  overflow-y: auto;
  padding: 24px;
}

.form-section {
  margin-bottom: 32px;
}

.form-section:last-child {
  margin-bottom: 0;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--color-text);
  margin-bottom: 16px;
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group.full-width {
  grid-column: 1 / -1;
}

.form-label {
  font-size: 14px;
  font-weight: 500;
  color: var(--color-text);
}

.textarea {
  resize: vertical;
  min-height: 80px;
  font-family: inherit;
  padding: 10px 14px;
}

.icon-selector {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.icon-btn {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  border-radius: var(--radius-sm);
  border: 2px solid var(--color-border);
  background: var(--color-surface);
  transition: var(--transition);
}

.icon-btn:hover {
  border-color: var(--color-primary);
  transform: scale(1.1);
}

.icon-btn.selected {
  border-color: var(--color-primary);
  background: rgba(0, 113, 227, 0.1);
}

.color-selector {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.color-btn {
  width: 40px;
  height: 40px;
  border-radius: var(--radius-sm);
  border: 3px solid transparent;
  transition: var(--transition);
  position: relative;
}

.color-btn:hover {
  transform: scale(1.1);
}

.color-btn.selected {
  border-color: var(--color-text);
  box-shadow: 0 0 0 2px var(--color-surface), 0 0 0 4px var(--color-primary);
}

.fields-list {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.field-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.multiselect {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 12px;
  background: var(--color-bg);
  border-radius: var(--radius-sm);
  border: 1px solid var(--color-border);
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: var(--color-text);
  cursor: pointer;
}

.checkbox-label input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
  accent-color: var(--color-primary);
}

.modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 24px;
  border-top: 1px solid var(--color-border);
  background: var(--color-bg);
}
</style>
