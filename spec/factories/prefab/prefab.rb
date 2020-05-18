# frozen_string_literal: true

def prefab_authority_object
  build(
    :collection_space_object,
    category: 'Authority',
    type: 'Person',
    subtype: 'person',
    identifier_field: 'shortIdentifier',
    identifier: 'Mickey Mouse',
    title: 'Mickey Mouse'
  )
end

def prefab_data
  {
    converter_profile: 'cataloging',
    import_batch: 'cataloging1',
    import_category: 'Procedures',
    import_file: 'cataloging1.csv',
    csv_data: { objectnumber: '123' }
  }
end

def prefab_data_object
  build(
    :data_object,
    converter_profile: 'cataloging',
    import_batch: 'cataloging1',
    import_category: 'Procedures',
    import_file: 'cataloging1.csv',
    csv_data: { objectnumber: '123' }
  )
end

def prefab_procedure_object
  build(
    :collection_space_object,
    category: 'Procedure',
    type: 'Acquisition',
    identifier_field: 'acquisitionReferenceNumber',
    identifier: '123',
    title: 'Fly in ointment.'
  )
end

def prefab_relationship_object
  build(
    :collection_space_object,
    category: 'Relationship',
    type: 'Relationship',
    identifier_field: 'csid',
    identifier: '123',
    title: '123'
  )
end

def prefab_vocabulary_object
  build(
    :collection_space_object,
    category: 'Vocabulary',
    type: 'vocabularies',
    subtype: 'languages',
    identifier_field: 'shortIdentifier',
    identifier: 'danish',
    title: 'Danish'
  )
end
