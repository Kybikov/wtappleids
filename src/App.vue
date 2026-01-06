<template>
  <div class="app">
    <header class="header">
      <div class="header-content">
        <div class="header-left">
          <h1 class="logo">Apple Family Manager</h1>
        </div>

        <div class="header-center">
          <div class="search-bar">
            <svg class="search-icon" width="16" height="16" viewBox="0 0 16 16" fill="none">
              <path d="M7 13C10.3137 13 13 10.3137 13 7C13 3.68629 10.3137 1 7 1C3.68629 1 1 3.68629 1 7C1 10.3137 3.68629 13 7 13Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              <path d="M11.5 11.5L15 15" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Поиск семей..."
              class="search-input"
            />
          </div>
        </div>

        <div class="header-right">
          <div class="view-switcher">
            <button
              :class="['view-btn', { active: currentView === 'kanban' }]"
              @click="currentView = 'kanban'"
            >
              <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                <rect x="1" y="1" width="6" height="16" rx="1" stroke="currentColor" stroke-width="1.5"/>
                <rect x="11" y="1" width="6" height="10" rx="1" stroke="currentColor" stroke-width="1.5"/>
              </svg>
            </button>
            <button
              :class="['view-btn', { active: currentView === 'list' }]"
              @click="currentView = 'list'"
            >
              <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                <path d="M1 3H17M1 9H17M1 15H17" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              </svg>
            </button>
          </div>

          <button class="btn btn-primary" @click="showCreateModal = true">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
              <path d="M8 1V15M1 8H15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
            Добавить семью
          </button>
        </div>
      </div>
    </header>

    <div class="toolbar">
      <div class="toolbar-content">
        <div class="toolbar-left">
          <select v-model="groupBy" class="toolbar-select">
            <option value="">Без группировки</option>
            <option value="status">По статусу</option>
            <option value="color">По цвету</option>
          </select>

          <select v-model="sortBy" class="toolbar-select">
            <option value="position">По позиции</option>
            <option value="name">По имени</option>
            <option value="created_at">По дате создания</option>
          </select>

          <select v-model="filterStatus" class="toolbar-select">
            <option value="">Все статусы</option>
            <option value="active">Активные</option>
            <option value="inactive">Неактивные</option>
            <option value="archived">Архив</option>
          </select>
        </div>

        <div class="toolbar-right">
          <span class="count-badge">{{ filteredFamilies.length }} семей</span>
        </div>
      </div>
    </div>

    <main class="main">
      <KanbanView
        v-if="currentView === 'kanban'"
        :families="filteredFamilies"
        :field-definitions="fieldDefinitions"
        @edit="editFamily"
        @delete="deleteFamily"
      />
      <ListView
        v-else
        :families="filteredFamilies"
        :field-definitions="fieldDefinitions"
        @edit="editFamily"
        @delete="deleteFamily"
      />
    </main>

    <FamilyModal
      v-if="showCreateModal || editingFamily"
      :family="editingFamily"
      :field-definitions="fieldDefinitions"
      @close="closeModal"
      @save="saveFamily"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useFamilies } from './composables/useFamilies';
import KanbanView from './components/KanbanView.vue';
import ListView from './components/ListView.vue';
import FamilyModal from './components/FamilyModal.vue';

const {
  families,
  fieldDefinitions,
  familiesWithFields,
  loading,
  fetchFamilies,
  fetchFieldDefinitions,
  fetchFieldValues,
  createFamily,
  updateFamily,
  deleteFamily: deleteFamilyApi
} = useFamilies();

const currentView = ref('kanban');
const searchQuery = ref('');
const groupBy = ref('');
const sortBy = ref('position');
const filterStatus = ref('');
const showCreateModal = ref(false);
const editingFamily = ref(null);

onMounted(async () => {
  await Promise.all([
    fetchFamilies(),
    fetchFieldDefinitions(),
    fetchFieldValues()
  ]);
});

const filteredFamilies = computed(() => {
  let result = [...familiesWithFields.value];

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(f =>
      f.name.toLowerCase().includes(query) ||
      f.description.toLowerCase().includes(query)
    );
  }

  if (filterStatus.value) {
    result = result.filter(f => f.status === filterStatus.value);
  }

  result.sort((a, b) => {
    if (sortBy.value === 'name') {
      return a.name.localeCompare(b.name);
    } else if (sortBy.value === 'created_at') {
      return new Date(b.created_at) - new Date(a.created_at);
    } else {
      return a.position - b.position;
    }
  });

  return result;
});

const editFamily = (family) => {
  editingFamily.value = family;
};

const deleteFamily = async (family) => {
  if (confirm(`Удалить семью "${family.name}"?`)) {
    await deleteFamilyApi(family.id);
  }
};

const closeModal = () => {
  showCreateModal.value = false;
  editingFamily.value = null;
};

const saveFamily = async (familyData) => {
  if (editingFamily.value) {
    await updateFamily(editingFamily.value.id, familyData);
  } else {
    await createFamily(familyData);
  }
  closeModal();
};
</script>

<style scoped>
.app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  background: var(--color-surface);
  border-bottom: 1px solid var(--color-border);
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: var(--shadow-sm);
}

.header-content {
  max-width: 1600px;
  margin: 0 auto;
  padding: 16px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
}

.header-left,
.header-center,
.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-center {
  flex: 1;
  max-width: 600px;
}

.logo {
  font-size: 20px;
  font-weight: 600;
  color: var(--color-text);
}

.search-bar {
  position: relative;
  width: 100%;
}

.search-icon {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--color-text-secondary);
}

.search-input {
  width: 100%;
  padding: 10px 14px 10px 42px;
  border-radius: var(--radius-sm);
  border: 1px solid var(--color-border);
  background: var(--color-bg);
  font-size: 14px;
  transition: var(--transition);
}

.search-input:focus {
  border-color: var(--color-primary);
  background: var(--color-surface);
  box-shadow: 0 0 0 3px rgba(0, 113, 227, 0.1);
}

.view-switcher {
  display: flex;
  gap: 4px;
  background: var(--color-bg);
  padding: 4px;
  border-radius: var(--radius-sm);
}

.view-btn {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 6px;
  color: var(--color-text-secondary);
  transition: var(--transition);
}

.view-btn:hover {
  color: var(--color-text);
  background: var(--color-surface);
}

.view-btn.active {
  background: var(--color-surface);
  color: var(--color-primary);
  box-shadow: var(--shadow-sm);
}

.toolbar {
  background: var(--color-surface);
  border-bottom: 1px solid var(--color-border);
}

.toolbar-content {
  max-width: 1600px;
  margin: 0 auto;
  padding: 12px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.toolbar-left,
.toolbar-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.toolbar-select {
  padding: 8px 12px;
  border-radius: var(--radius-sm);
  border: 1px solid var(--color-border);
  background: var(--color-surface);
  font-size: 13px;
  color: var(--color-text);
  cursor: pointer;
  transition: var(--transition);
}

.toolbar-select:hover {
  border-color: var(--color-primary);
}

.toolbar-select:focus {
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(0, 113, 227, 0.1);
}

.count-badge {
  padding: 6px 12px;
  background: var(--color-bg);
  border-radius: 12px;
  font-size: 13px;
  font-weight: 500;
  color: var(--color-text-secondary);
}

.main {
  flex: 1;
  max-width: 1600px;
  width: 100%;
  margin: 0 auto;
  padding: 24px;
}
</style>
