module CollectionSpace
  module Converter
    module Vanilla

      def self.registered_procedures
        [
          "CollectionObject",
          "Exhibition",
          "LoanIn",
          "LoanOut",
          "Media",
          "Intake",
          "Acquisition",
        ]
      end

      def self.registered_profiles
        {
          "cataloging" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "id_number",
                "title" => "id_number",
              },
            },
            "Authorities" => {
              "Person" => ["content_person", "inscriber", "production_person"],
              "Organization" => ["production_org"],
            },
            "Relationships" => [
              {
              },
            ],
          },
          "exhibition" => {
            "Procedures" => {
              "Exhibition" => {
                "identifier_field" => "exhibitionNumber",
                "identifier" => "exhibition_number",
                "title" => "exhibition_number",
              },
            },
            "Authorities" => {
              "Organization" => ["organizer"],
            },
            "Relationships" => [
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_1",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_2",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_3",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_4",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_5",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_6",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
            ],
          },
          "loanin" => {
            "Procedures" => {
              "LoanIn" => {
                "identifier_field" => "loanInNumber",
                "identifier" => "loan_in_number",
                "title" => "loan_in_number",
               },
             },
             "Authorities" => {
               "Person" => ["lender's_authorizer", "borrower's_authorizer"],
               "Organization" => ["lender"],
             },
             "Relationships" => [
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_1",
                  "procedure2_type" => "LoanIn",
                  "data2_field" => "loan_in_number",
               },
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_2",
                  "procedure2_type" => "LoanIn",
                  "data2_field" => "loan_in_number",
               },
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_3",
                  "procedure2_type" => "LoanIn",
                  "data2_field" => "loan_in_number",
               },
             ],
           },
           "loanout" => {
             "Procedures" => {
               "LoanOut" => {
                 "identifier_field" => "loanOutNumber",
                 "identifier" => "loan_out_number",
                 "title" => "loan_out_number",
               },
             },
             "Authorities" => {
               "Person" => ["lender's_authorizer", "borrower's_authorizer"],
               "Organization" => ["borrower"],
             },
             "Relationships" => [
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_1",
                  "procedure2_type" => "LoanOut",
                  "data2_field" => "loan_out_number",
               },
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_2",
                  "procedure2_type" => "LoanOut",
                  "data2_field" => "loan_out_number",
               },
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_3",
                  "procedure2_type" => "LoanOut",
                  "data2_field" => "loan_out_number",
               },
             ],
           },
           "media" => {
             "Procedures" => {
               "Media" => {
                 "identifier_field" => "identificationNumber",
                 "identifier" => "identification_number",
                 "title" => "identification_number",
               },
             },
             "Authorities" => {
             },
             "Relationships" => [
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "relationship",
                 "procedure2_type" => "Media",
                 "data2_field" => "identification_number",
               },
             ],
           },
           "intake" => {
             "Procedures" => {
               "Intake" => {
                 "identifier_field" => "entryNumber",
                 "identifier" => "intake_entry_number",
                 "title" => "intake_entry_number",
               },
             },
             "Authorities" => {
              "Person" => ["current_owner"],
             },
             "Relationships" => [
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "relationship_1",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "relationship_2",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "relationship_3",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
               {
                 "procedure1_type" => "Media",
                 "data1_field" => "relationship_4",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
               {
                 "procedure1_type" => "Media",
                 "data1_field" => "relationship_5",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
             ],
           },
           "acquisition" => {
             "Procedures" => {
               "Acquisition" => {
                 "identifier_field" => "acquisitionReferenceNumber",
                 "identifier" => "acquisition_reference_number",
                 "title" => "acquisition_reference_number",
               },
             },
             "Authorities" => {
              "Person" => ["acquisition_authorizer", "owner"],
            },
            "Relationships" => [
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_1",
                "procedure2_type" => "Acquisition",
                "data2_field" => "acquisition_reference_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_2",
                "procedure2_type" => "Acquisition",
                "data2_field" => "acquisition_reference_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_3",
                "procedure2_type" => "Acquisition",
                "data2_field" => "acquisition_reference_number",
              },
              {
                "procedure1_type" => "Intake",
                "data1_field" => "relationship_4",
                "procedure2_type" => "Acquisition",
                "data2_field" => "acquisition_reference_number",
              },
            ],
          },

        }
      end

    end
  end
end