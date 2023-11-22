```mermaid
classDiagram
    class FileDirectory {
        -String path
        +Array~String~ files()
        +FileMetaData get_file_metadata(String filename)
    }

    class FileMetaData {
        +String file_type
        +String permissions
        +int links
        +String owner
        +String group
        +int size
        +DateTime last_modified
        +FileMetaData(attributes)
    }

    class LsOption {
        -Hash options
        +boolean option_set?(String option)
        +void parse(String[] args)
    }

    class LsCommand {
        -LsOption option
        -FileDirectory fileDirectory
        +void run_ls()
        -void show_detailed_list(String[] prepared_files)
        -void show_simple_list(String[] prepared_files)
        -Array~String~ prepare_file_list(String[] file_names)
        -Array~String~ filter_files(String[] file_names)
        -Array~String~ sort_files(String[] file_names)
        -Array~String~ format_file_list(String[] file_names)
        -Array~String~ calculate_max_size_length_and_total_blocks(String[] file_names)
        -String[] format_single_file_stat(String file_name, int max_size_length)
        -Array~String~ parse_argv(String[] argv)
    }

    FileDirectory "1" -- "1" LsCommand: uses
    FileMetaData "1" -- "*" FileDirectory: creates
    LsOption "1" -- "1" LsCommand: uses
