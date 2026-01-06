import { ref, computed } from 'vue';
import { supabase } from '../utils/supabase';

const families = ref([]);
const fieldDefinitions = ref([]);
const fieldValues = ref([]);
const loading = ref(false);
const error = ref(null);

export function useFamilies() {
  const fetchFamilies = async () => {
    try {
      loading.value = true;
      error.value = null;

      const { data, error: fetchError } = await supabase
        .from('families')
        .select('*')
        .order('position', { ascending: true });

      if (fetchError) throw fetchError;
      families.value = data || [];
    } catch (e) {
      error.value = e.message;
      console.error('Error fetching families:', e);
    } finally {
      loading.value = false;
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

  const createFamily = async (familyData) => {
    try {
      loading.value = true;
      error.value = null;

      const { data, error: insertError } = await supabase
        .from('families')
        .insert([familyData])
        .select()
        .single();

      if (insertError) throw insertError;
      families.value.push(data);
      return data;
    } catch (e) {
      error.value = e.message;
      console.error('Error creating family:', e);
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const updateFamily = async (id, updates) => {
    try {
      loading.value = true;
      error.value = null;

      const { data, error: updateError } = await supabase
        .from('families')
        .update({ ...updates, updated_at: new Date().toISOString() })
        .eq('id', id)
        .select()
        .single();

      if (updateError) throw updateError;

      const index = families.value.findIndex(f => f.id === id);
      if (index !== -1) {
        families.value[index] = data;
      }
      return data;
    } catch (e) {
      error.value = e.message;
      console.error('Error updating family:', e);
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const deleteFamily = async (id) => {
    try {
      loading.value = true;
      error.value = null;

      const { error: deleteError } = await supabase
        .from('families')
        .delete()
        .eq('id', id);

      if (deleteError) throw deleteError;

      families.value = families.value.filter(f => f.id !== id);
    } catch (e) {
      error.value = e.message;
      console.error('Error deleting family:', e);
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const updateFieldValue = async (familyId, fieldId, value) => {
    try {
      const { data, error: upsertError } = await supabase
        .from('field_values')
        .upsert({
          family_id: familyId,
          field_id: fieldId,
          value: value,
          updated_at: new Date().toISOString()
        }, {
          onConflict: 'family_id,field_id'
        })
        .select()
        .single();

      if (upsertError) throw upsertError;

      const index = fieldValues.value.findIndex(
        fv => fv.family_id === familyId && fv.field_id === fieldId
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

  const getFieldValue = (familyId, fieldId) => {
    const fieldValue = fieldValues.value.find(
      fv => fv.family_id === familyId && fv.field_id === fieldId
    );
    return fieldValue?.value || null;
  };

  const familiesWithFields = computed(() => {
    return families.value.map(family => {
      const fields = {};
      fieldDefinitions.value.forEach(field => {
        fields[field.id] = getFieldValue(family.id, field.id);
      });
      return {
        ...family,
        fields
      };
    });
  });

  return {
    families,
    fieldDefinitions,
    fieldValues,
    familiesWithFields,
    loading,
    error,
    fetchFamilies,
    fetchFieldDefinitions,
    fetchFieldValues,
    createFamily,
    updateFamily,
    deleteFamily,
    updateFieldValue,
    getFieldValue
  };
}
