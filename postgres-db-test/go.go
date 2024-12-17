// type GenericStorageError struct {
//     message: string
//     code: int
//     cause: error
// };

// func (*GenericStorageError) Error() string {
//     return fmt.Sprintf("message: %s, code: %d, cause: %v", e.message, e.code, e.cause)
// }


// type InserErrop struct {
//     *GenericStorageError
// };

// func (*InsertError) Error() string {
//     return fmt.Sprintf("insert error: %s", e.GenericStorageError.Error())
// }


// func Save() error {
//     if err := insert(); err != nil {
//         return &InsertError{&GenericStorageError{message: "insert failed", code: 100, cause: err}}
//     }
//     return nil
// }


// func main() {
//     err := Save()
//     if err.(*InsertError) {
//         fmt.Println("insert error")
//     } else {
//         fmt.Println("other error")
//     }
// }
