abstract class TodoUsecase {
  void initTodoState();
  void onSubmit(String? value);
  String onChanged(String? value);
  void deleteItem(int index);
  bool isAvailableItem(String? value);
  void addItem();
  void clickUpdate(int index);
  void update();
  void resetUpdate();
  void checkItem(bool? value, int index);
  void afterDelete();
}