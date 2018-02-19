from typing import Callable, Any, Dict, Type

class SerializerBase:
  @staticmethod
  def register_dict_to_class(classname: str, cb: Callable[[str, Dict[Any, Any]], Any]) -> None: ...
  @staticmethod
  def register_class_to_dict(clazz: Type, cb: Callable[[Any], Dict[Any, Any]]) -> None: ...
