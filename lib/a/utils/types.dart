/* -= Comparing Types =- */

bool isExactType<TypeA, TypeB>() => TypeA == TypeB;

bool isSuperType<SuperType, SubType>() => <SubType>[] is List<SuperType>;

bool isSubType<SubType, SuperType>() => isSuperType<SuperType, SubType>();

bool isAssignable<InstanceType, AssignToType>() =>
  isExactType<InstanceType, AssignToType>() || isSubType<InstanceType, AssignToType>();