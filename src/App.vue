<template>
  <div class="app">
    <header class="header">
      <div class="header-content">
        <div class="header-left">
          <div class="logo">
            <span class="logo-icon">🍉</span>
            <h1 class="logo-text">Apple Accounts</h1>
          </div>
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
              placeholder="Search accounts..."
              class="search-input"
            />
          </div>
        </div>

        <div class="header-right">
          <div class="view-switcher">
            <button
              :class="['view-btn', { active: currentView === 'kanban' }]"
              @click="currentView = 'kanban'"
              title="Kanban View"
            >
              <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                <rect x="1" y="1" width="6" height="16" rx="1" stroke="currentColor" stroke-width="1.5"/>
                <rect x="11" y="1" width="6" height="10" rx="1" stroke="currentColor" stroke-width="1.5"/>
              </svg>
            </button>
            <button
              :class="['view-btn', { active: currentView === 'list' }]"
              @click="currentView = 'list'"
              title="List View"
            >
              <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                <path d="M1 3H17M1 9H17M1 15H17" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              </svg>
            </button>
          </div>

          <button class="btn-icon" @click="showSettings = true" title="Settings">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
              <path d="M10 12.5C11.3807 12.5 12.5 11.3807 12.5 10C12.5 8.61929 11.3807 7.5 10 7.5C8.61929 7.5 7.5 8.61929 7.5 10C7.5 11.3807 8.61929 12.5 10 12.5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M16.1667 12.5C16.0557 12.7513 16.0228 13.0301 16.0722 13.3006C16.1216 13.5711 16.2512 13.8203 16.4417 14.0167L16.4917 14.0667C16.6445 14.2192 16.7655 14.4007 16.8478 14.6006C16.9302 14.8005 16.9722 15.0149 16.9722 15.2313C16.9722 15.4477 16.9302 15.6621 16.8478 15.862C16.7655 16.0619 16.6445 16.2435 16.4917 16.396C16.3392 16.5488 16.1577 16.6698 15.9578 16.7521C15.7579 16.8345 15.5434 16.8765 15.327 16.8765C15.1107 16.8765 14.8962 16.8345 14.6963 16.7521C14.4964 16.6698 14.3149 16.5488 14.1623 16.396L14.1123 16.346C13.916 16.1555 13.6668 16.0259 13.3963 15.9765C13.1258 15.9271 12.847 15.96 12.5957 16.071C12.3498 16.1769 12.1409 16.3534 11.996 16.5787C11.8511 16.804 11.7763 17.0684 11.7807 17.3373V17.5C11.7807 17.9418 11.6051 18.3656 11.2925 18.6782C10.9799 18.9908 10.5561 19.1663 10.1143 19.1663C9.67255 19.1663 9.24871 18.9908 8.93615 18.6782C8.62359 18.3656 8.44801 17.9418 8.44801 17.5V17.425C8.44367 17.1494 8.36042 16.8809 8.20803 16.6528C8.05563 16.4247 7.84064 16.2465 7.58968 16.1393C7.33838 16.0283 7.05959 15.9954 6.78909 16.0448C6.51859 16.0942 6.26938 16.2238 6.07301 16.4143L6.02301 16.4643C5.87052 16.6171 5.68896 16.7381 5.48908 16.8205C5.28919 16.9028 5.07473 16.9448 4.85835 16.9448C4.64197 16.9448 4.4275 16.9028 4.22762 16.8205C4.02774 16.7381 3.84617 16.6171 3.69368 16.4643C3.54088 16.3118 3.4199 16.1303 3.33755 15.9304C3.25521 15.7305 3.21317 15.516 3.21317 15.2997C3.21317 15.0833 3.25521 14.8688 3.33755 14.6689C3.4199 14.469 3.54088 14.2875 3.69368 14.135L3.74368 14.085C3.93416 13.8886 4.06376 13.6394 4.11316 13.3689C4.16255 13.0984 4.12968 12.8196 4.01868 12.5683C3.91278 12.3224 3.73627 12.1135 3.511 11.9686C3.28573 11.8237 3.02131 11.7489 2.75234 11.7533H2.58968C2.14791 11.7533 1.72407 11.5778 1.41151 11.2652C1.09895 10.9526 0.923363 10.5288 0.923363 10.087C0.923363 9.64522 1.09895 9.22137 1.41151 8.90881C1.72407 8.59625 2.14791 8.42067 2.58968 8.42067H2.66468C2.94028 8.41633 3.20877 8.33308 3.43685 8.18068C3.66493 8.02829 3.84312 7.81329 3.95035 7.56233C4.06135 7.31103 4.09421 7.03224 4.04482 6.76174C3.99542 6.49124 3.86582 6.24203 3.67534 6.04567L3.62534 5.99567C3.47254 5.84317 3.35157 5.66161 3.26922 5.46173C3.18687 5.26185 3.14484 5.04738 3.14484 4.831C3.14484 4.61462 3.18687 4.40016 3.26922 4.20027C3.35157 4.00039 3.47254 3.81883 3.62534 3.66633C3.77784 3.51353 3.9594 3.39256 4.15928 3.31021C4.35916 3.22786 4.57363 3.18583 4.79001 3.18583C5.00639 3.18583 5.22085 3.22786 5.42074 3.31021C5.62062 3.39256 5.80218 3.51353 5.95468 3.66633L6.00468 3.71633C6.20103 3.90682 6.45024 4.03642 6.72074 4.08581C6.99124 4.1352 7.27003 4.10234 7.52134 3.99133H7.58968C7.83554 3.88543 8.04447 3.70892 8.18938 3.48365C8.33429 3.25838 8.40906 2.99396 8.40468 2.725V2.56233C8.40468 2.12056 8.58026 1.69672 8.89282 1.38416C9.20538 1.0716 9.62923 0.896011 10.071 0.896011C10.5128 0.896011 10.9366 1.0716 11.2492 1.38416C11.5617 1.69672 11.7373 2.12056 11.7373 2.56233V2.63733C11.7327 2.90629 11.8075 3.17071 11.9524 3.39598C12.0973 3.62125 12.3062 3.79776 12.5521 3.90367C12.8034 4.01467 13.0822 4.04753 13.3527 3.99814C13.6232 3.94874 13.8724 3.81914 14.0688 3.62867L14.1188 3.57867C14.2713 3.42586 14.4528 3.30489 14.6527 3.22254C14.8526 3.1402 15.0671 3.09816 15.2834 3.09816C15.4998 3.09816 15.7143 3.1402 15.9142 3.22254C16.1141 3.30489 16.2956 3.42586 16.4481 3.57867C16.6009 3.73116 16.7219 3.91272 16.8042 4.1126C16.8866 4.31249 16.9286 4.52695 16.9286 4.74333C16.9286 4.95971 16.8866 5.17418 16.8042 5.37406C16.7219 5.57395 16.6009 5.75551 16.4481 5.908L16.3981 5.958C16.2076 6.15436 16.078 6.40357 16.0286 6.67407C15.9792 6.94457 16.0121 7.22336 16.1231 7.47467V7.543C16.229 7.78886 16.4055 7.99779 16.6308 8.1427C16.856 8.28761 17.1205 8.36238 17.3894 8.358H17.5521C17.9938 8.358 18.4177 8.53359 18.7302 8.84615C19.0428 9.15871 19.2184 9.58255 19.2184 10.0243C19.2184 10.4661 19.0428 10.8899 18.7302 11.2025C18.4177 11.5151 17.9938 11.6906 17.5521 11.6906H17.4771C17.2081 11.6953 16.9437 11.77 16.7184 11.9149C16.4932 12.0599 16.3166 12.2688 16.2107 12.5147V12.5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>

          <button class="btn btn-primary" @click="showCreateModal = true">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
              <path d="M8 1V15M1 8H15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
            Add Apple Account
          </button>
        </div>
      </div>
    </header>

    <div class="toolbar">
      <div class="toolbar-content">
        <div class="toolbar-left">
          <select v-model="sortBy" class="toolbar-select">
            <option value="position">Sort: Position</option>
            <option value="name">Sort: Name</option>
            <option value="created_at">Sort: Date Created</option>
          </select>

          <select v-model="filterStatus" class="toolbar-select">
            <option value="">All Statuses</option>
            <option
              v-for="status in statuses"
              :key="status.id"
              :value="status.id"
            >
              {{ status.name }}
            </option>
          </select>
        </div>

        <div class="toolbar-right">
          <span class="count-badge">
            <span class="count-number">{{ filteredAccounts.length }}</span>
            accounts
          </span>
        </div>
      </div>
    </div>

    <main class="main">
      <KanbanView
        v-if="currentView === 'kanban'"
        :accounts="filteredAccounts"
        :statuses="statuses"
        :field-definitions="fieldDefinitions"
        @edit="editAccount"
        @delete="deleteAccount"
      />
      <ListView
        v-else
        :accounts="filteredAccounts"
        :statuses="statuses"
        :field-definitions="fieldDefinitions"
        @edit="editAccount"
        @delete="deleteAccount"
      />
    </main>

    <AccountModal
      v-if="showCreateModal || editingAccount"
      :account="editingAccount"
      :statuses="statuses"
      :field-definitions="fieldDefinitions"
      @close="closeModal"
      @save="saveAccount"
    />

    <SettingsModal
      v-if="showSettings"
      :statuses="statuses"
      :field-definitions="fieldDefinitions"
      @close="showSettings = false"
      @create-status="handleCreateStatus"
      @delete-status="handleDeleteStatus"
      @create-field="handleCreateField"
      @delete-field="handleDeleteField"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useAccounts } from './composables/useAccounts';
import KanbanView from './components/KanbanView.vue';
import ListView from './components/ListView.vue';
import AccountModal from './components/AccountModal.vue';
import SettingsModal from './components/SettingsModal.vue';

const {
  accounts,
  statuses,
  fieldDefinitions,
  accountsWithFields,
  loading,
  fetchAccounts,
  fetchStatuses,
  fetchFieldDefinitions,
  fetchFieldValues,
  createAccount,
  updateAccount,
  deleteAccount: deleteAccountApi,
  createStatus,
  deleteStatus,
  createFieldDefinition,
  deleteFieldDefinition
} = useAccounts();

const currentView = ref('kanban');
const searchQuery = ref('');
const sortBy = ref('position');
const filterStatus = ref('');
const showCreateModal = ref(false);
const showSettings = ref(false);
const editingAccount = ref(null);

onMounted(async () => {
  await Promise.all([
    fetchStatuses(),
    fetchFieldDefinitions(),
    fetchAccounts(),
    fetchFieldValues()
  ]);
});

const filteredAccounts = computed(() => {
  let result = [...accountsWithFields.value];

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(a =>
      a.name.toLowerCase().includes(query) ||
      a.description.toLowerCase().includes(query)
    );
  }

  if (filterStatus.value) {
    result = result.filter(a => a.status_id === filterStatus.value);
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

const editAccount = (account) => {
  editingAccount.value = account;
};

const deleteAccount = async (account) => {
  if (confirm(`Delete account "${account.name}"?`)) {
    await deleteAccountApi(account.id);
  }
};

const closeModal = () => {
  showCreateModal.value = false;
  editingAccount.value = null;
};

const saveAccount = async (accountData) => {
  if (editingAccount.value) {
    await updateAccount(editingAccount.value.id, accountData);
  } else {
    await createAccount(accountData);
  }
  closeModal();
};

const handleCreateStatus = async (statusData) => {
  await createStatus(statusData);
};

const handleDeleteStatus = async (statusId) => {
  await deleteStatus(statusId);
};

const handleCreateField = async (fieldData) => {
  await createFieldDefinition(fieldData);
};

const handleDeleteField = async (fieldId) => {
  await deleteFieldDefinition(fieldId);
};
</script>

<style scoped>
.app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  background: linear-gradient(135deg, #ffffff 0%, #fff5f7 100%);
  border-bottom: 2px solid var(--color-border);
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: var(--shadow-md);
}

.header-content {
  max-width: 1600px;
  margin: 0 auto;
  padding: 20px 32px;
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
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  font-size: 32px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-5px);
  }
}

.logo-text {
  font-size: 24px;
  font-weight: 700;
  background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.search-bar {
  position: relative;
  width: 100%;
}

.search-icon {
  position: absolute;
  left: 16px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--color-text-secondary);
  pointer-events: none;
}

.search-input {
  width: 100%;
  padding: 12px 16px 12px 44px;
  border-radius: var(--radius-sm);
  border: 2px solid var(--color-border);
  background: var(--color-surface);
  font-size: 14px;
  transition: var(--transition);
}

.search-input:focus {
  border-color: var(--color-primary);
  background: var(--color-surface);
  box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
}

.search-input::placeholder {
  color: var(--color-text-secondary);
}

.view-switcher {
  display: flex;
  gap: 6px;
  background: var(--color-surface);
  padding: 6px;
  border-radius: var(--radius-sm);
  border: 2px solid var(--color-border);
}

.view-btn {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  color: var(--color-text-secondary);
  transition: var(--transition);
}

.view-btn:hover {
  color: var(--color-text);
  background: var(--color-surface-hover);
}

.view-btn.active {
  background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
  color: white;
  box-shadow: var(--shadow-sm);
}

.btn-icon {
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-sm);
  color: var(--color-text);
  background: var(--color-surface);
  border: 2px solid var(--color-border);
  transition: var(--transition);
}

.btn-icon:hover {
  border-color: var(--color-primary);
  transform: translateY(-2px);
  box-shadow: var(--shadow-sm);
}

.toolbar {
  background: var(--color-surface);
  border-bottom: 2px solid var(--color-border);
}

.toolbar-content {
  max-width: 1600px;
  margin: 0 auto;
  padding: 16px 32px;
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
  padding: 10px 16px;
  border-radius: var(--radius-sm);
  border: 2px solid var(--color-border);
  background: var(--color-surface);
  font-size: 14px;
  font-weight: 500;
  color: var(--color-text);
  cursor: pointer;
  transition: var(--transition);
}

.toolbar-select:hover {
  border-color: var(--color-primary);
}

.toolbar-select:focus {
  border-color: var(--color-primary);
  box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
}

.count-badge {
  padding: 8px 16px;
  background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
  border-radius: 20px;
  font-size: 14px;
  font-weight: 600;
  color: white;
  display: flex;
  align-items: center;
  gap: 6px;
}

.count-number {
  font-size: 18px;
  font-weight: 700;
}

.main {
  flex: 1;
  max-width: 1600px;
  width: 100%;
  margin: 0 auto;
  padding: 32px;
}
</style>
