import { ref, computed } from 'vue';
import { supabase } from '../utils/supabase';

const accounts = ref([]);
const statuses = ref([]);
const fieldDefinitions = ref([]);
const fieldValues = ref([]);
const loading = ref(false);
const error = ref(null);

export function useAccounts() {
  const fetchAccounts = async () => {
    try {
      loading.value = true;
      error.value = null;

      const { data, error: fetchError } = await supabase
        .from('accounts')
        .select('*, statuses(*)')
        .order('position', { ascending: true });

      if (fetchError) throw fetchError;
      accounts.value = data || [];
    } catch (e) {
      error.value = e.message;
      console.error('Error fetching accounts:', e);
    } finally {
      loading.value = false;
    }
  };

  const fetchStatuses = async () => {
    try {
      const { data, error: fetchError } = await supabase
        .from('statuses')
        .select('*')
        .order('position', { ascending: true });

      if (fetchError) throw fetchError;
      statuses.value = data || [];
    } catch (e) {
      console.error('Error fetching statuses:', e);
    }
  };

  const fetchFieldDefinitions = async () => {
    try {
      const { data, error: fetchError } = await supabase
        .from('field_definitions')
        .select('*')
        .order('position', { ascending: true });

      if (fetchError) throw fetchError;
      fieldDefinitions.value = data || [];
    } catch (e) {
      console.error('Error fetching field definitions:', e);
    }
  };

  const fetchFieldValues = async () => {
    try {
      const { data, error: fetchError } = await supabase
        .from('field_values')
        .select('*');

      if (fetchError) throw fetchError;
      fieldValues.value = data || [];
    } catch (e) {
      console.error('Error fetching field values:', e);
    }
  };

  const createAccount = async (accountData) => {
    try {
      loading.value = true;
      error.value = null;

      const { data, error: insertError } = await supabase
        .from('accounts')
        .insert([accountData])
        .select('*, statuses(*)')
        .single();

      if (insertError) throw insertError;
      accounts.value.push(data);
      return data;
    } catch (e) {
      error.value = e.message;
      console.error('Error creating account:', e);
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const updateAccount = async (id, updates) => {
    try {
      loading.value = true;
      error.value = null;

      const { data, error: updateError } = await supabase
        .from('accounts')
        .update({ ...updates, updated_at: new Date().toISOString() })
        .eq('id', id)
        .select('*, statuses(*)')
        .single();

      if (updateError) throw updateError;

      const index = accounts.value.findIndex(a => a.id === id);
      if (index !== -1) {
        accounts.value[index] = data;
      }
      return data;
    } catch (e) {
      error.value = e.message;
      console.error('Error updating account:', e);
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const deleteAccount = async (id) => {
    try {
      loading.value = true;
      error.value = null;

      const { error: deleteError } = await supabase
        .from('accounts')
        .delete()
        .eq('id', id);

      if (deleteError) throw deleteError;

      accounts.value = accounts.value.filter(a => a.id !== id);
    } catch (e) {
      error.value = e.message;
      console.error('Error deleting account:', e);
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const createStatus = async (statusData) => {
    try {
      const { data, error: insertError } = await supabase
        .from('statuses')
        .insert([statusData])
        .select()
        .single();

      if (insertError) throw insertError;
      statuses.value.push(data);
      return data;
    } catch (e) {
      console.error('Error creating status:', e);
      throw e;
    }
  };

  const updateStatus = async (id, updates) => {
    try {
      const { data, error: updateError } = await supabase
        .from('statuses')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

      if (updateError) throw updateError;

      const index = statuses.value.findIndex(s => s.id === id);
      if (index !== -1) {
        statuses.value[index] = data;
      }
      return data;
    } catch (e) {
      console.error('Error updating status:', e);
      throw e;
    }
  };

  const deleteStatus = async (id) => {
    try {
      const { error: deleteError } = await supabase
        .from('statuses')
        .delete()
        .eq('id', id);

      if (deleteError) throw deleteError;

      statuses.value = statuses.value.filter(s => s.id !== id);
    } catch (e) {
      console.error('Error deleting status:', e);
      throw e;
    }
  };

  const createFieldDefinition = async (fieldData) => {
    try {
      const { data, error: insertError } = await supabase
        .from('field_definitions')
        .insert([fieldData])
        .select()
        .single();

      if (insertError) throw insertError;
      fieldDefinitions.value.push(data);
      return data;
    } catch (e) {
      console.error('Error creating field definition:', e);
      throw e;
    }
  };

  const updateFieldDefinition = async (id, updates) => {
    try {
      const { data, error: updateError } = await supabase
        .from('field_definitions')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

      if (updateError) throw updateError;

      const index = fieldDefinitions.value.findIndex(f => f.id === id);
      if (index !== -1) {
        fieldDefinitions.value[index] = data;
      }
      return data;
    } catch (e) {
      console.error('Error updating field definition:', e);
      throw e;
    }
  };

  const deleteFieldDefinition = async (id) => {
    try {
      const { error: deleteError } = await supabase
        .from('field_definitions')
        .delete()
        .eq('id', id);

      if (deleteError) throw deleteError;

      fieldDefinitions.value = fieldDefinitions.value.filter(f => f.id !== id);
    } catch (e) {
      console.error('Error deleting field definition:', e);
      throw e;
    }
  };

  const updateFieldValue = async (accountId, fieldId, value) => {
    try {
      const { data, error: upsertError } = await supabase
        .from('field_values')
        .upsert({
          account_id: accountId,
          field_id: fieldId,
          value: value,
          updated_at: new Date().toISOString()
        }, {
          onConflict: 'account_id,field_id'
        })
        .select()
        .single();

      if (upsertError) throw upsertError;

      const index = fieldValues.value.findIndex(
        fv => fv.account_id === accountId && fv.field_id === fieldId
      );

      if (index !== -1) {
        fieldValues.value[index] = data;
      } else {
        fieldValues.value.push(data);
      }

      return data;
    } catch (e) {
      console.error('Error updating field value:', e);
      throw e;
    }
  };

  const getFieldValue = (accountId, fieldId) => {
    const fieldValue = fieldValues.value.find(
      fv => fv.account_id === accountId && fv.field_id === fieldId
    );
    return fieldValue?.value || null;
  };

  const accountsWithFields = computed(() => {
    return accounts.value.map(account => {
      const fields = {};
      fieldDefinitions.value.forEach(field => {
        fields[field.id] = getFieldValue(account.id, field.id);
      });
      return {
        ...account,
        fields
      };
    });
  });

  return {
    accounts,
    statuses,
    fieldDefinitions,
    fieldValues,
    accountsWithFields,
    loading,
    error,
    fetchAccounts,
    fetchStatuses,
    fetchFieldDefinitions,
    fetchFieldValues,
    createAccount,
    updateAccount,
    deleteAccount,
    createStatus,
    updateStatus,
    deleteStatus,
    createFieldDefinition,
    updateFieldDefinition,
    deleteFieldDefinition,
    updateFieldValue,
    getFieldValue
  };
}
