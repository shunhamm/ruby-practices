```mermaid
classDiagram
    class Path {
        -String path
        +Array~String~ files()
        +FileMetaData get_file_metadata(String filename)
    }

    class FileMetaData {
        +String name
        +DateTime lastModified
        +Integer size
        +String permissions
        +String owner
        +String group
    }

    class LsOption {
        -Hash options
        +boolean is_option_set(String option)
        -void parse_options(Array~String~ args)
    }

    class LsCommand {
        -LsOption options
        -Array~Path~ paths
        +void show_ls()
        -Array~String~ build_ls()
        -Array~String~ sort_files(Array~String~ files)
        -Array~String~ filter_files(Array~String~ files)
        -Array~String~ format_file_list(Array~FileMetaData~ fileData)
    }

    Path "1" -- "1" LsCommand: uses
    FileMetaData "1" -- "*" Path: has
    LsOption "1" -- "1" LsCommand: uses
