// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_roles_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmployeeRolesState {

 LoadStatus get status; EmployeeSummary? get employee; List<Role> get roles; bool get assigning; bool get assigned; Failure? get failure;
/// Create a copy of EmployeeRolesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeRolesStateCopyWith<EmployeeRolesState> get copyWith => _$EmployeeRolesStateCopyWithImpl<EmployeeRolesState>(this as EmployeeRolesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeRolesState&&(identical(other.status, status) || other.status == status)&&(identical(other.employee, employee) || other.employee == employee)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.assigning, assigning) || other.assigning == assigning)&&(identical(other.assigned, assigned) || other.assigned == assigned)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,employee,const DeepCollectionEquality().hash(roles),assigning,assigned,failure);

@override
String toString() {
  return 'EmployeeRolesState(status: $status, employee: $employee, roles: $roles, assigning: $assigning, assigned: $assigned, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $EmployeeRolesStateCopyWith<$Res>  {
  factory $EmployeeRolesStateCopyWith(EmployeeRolesState value, $Res Function(EmployeeRolesState) _then) = _$EmployeeRolesStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, EmployeeSummary? employee, List<Role> roles, bool assigning, bool assigned, Failure? failure
});




}
/// @nodoc
class _$EmployeeRolesStateCopyWithImpl<$Res>
    implements $EmployeeRolesStateCopyWith<$Res> {
  _$EmployeeRolesStateCopyWithImpl(this._self, this._then);

  final EmployeeRolesState _self;
  final $Res Function(EmployeeRolesState) _then;

/// Create a copy of EmployeeRolesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? employee = freezed,Object? roles = null,Object? assigning = null,Object? assigned = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,employee: freezed == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummary?,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<Role>,assigning: null == assigning ? _self.assigning : assigning // ignore: cast_nullable_to_non_nullable
as bool,assigned: null == assigned ? _self.assigned : assigned // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeRolesState].
extension EmployeeRolesStatePatterns on EmployeeRolesState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeRolesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeRolesState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeRolesState value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeRolesState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeRolesState value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeRolesState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  EmployeeSummary? employee,  List<Role> roles,  bool assigning,  bool assigned,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeRolesState() when $default != null:
return $default(_that.status,_that.employee,_that.roles,_that.assigning,_that.assigned,_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  EmployeeSummary? employee,  List<Role> roles,  bool assigning,  bool assigned,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _EmployeeRolesState():
return $default(_that.status,_that.employee,_that.roles,_that.assigning,_that.assigned,_that.failure);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  EmployeeSummary? employee,  List<Role> roles,  bool assigning,  bool assigned,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeRolesState() when $default != null:
return $default(_that.status,_that.employee,_that.roles,_that.assigning,_that.assigned,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _EmployeeRolesState implements EmployeeRolesState {
  const _EmployeeRolesState({this.status = LoadStatus.initial, this.employee, final  List<Role> roles = const <Role>[], this.assigning = false, this.assigned = false, this.failure}): _roles = roles;
  

@override@JsonKey() final  LoadStatus status;
@override final  EmployeeSummary? employee;
 final  List<Role> _roles;
@override@JsonKey() List<Role> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

@override@JsonKey() final  bool assigning;
@override@JsonKey() final  bool assigned;
@override final  Failure? failure;

/// Create a copy of EmployeeRolesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeRolesStateCopyWith<_EmployeeRolesState> get copyWith => __$EmployeeRolesStateCopyWithImpl<_EmployeeRolesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeRolesState&&(identical(other.status, status) || other.status == status)&&(identical(other.employee, employee) || other.employee == employee)&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.assigning, assigning) || other.assigning == assigning)&&(identical(other.assigned, assigned) || other.assigned == assigned)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,employee,const DeepCollectionEquality().hash(_roles),assigning,assigned,failure);

@override
String toString() {
  return 'EmployeeRolesState(status: $status, employee: $employee, roles: $roles, assigning: $assigning, assigned: $assigned, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$EmployeeRolesStateCopyWith<$Res> implements $EmployeeRolesStateCopyWith<$Res> {
  factory _$EmployeeRolesStateCopyWith(_EmployeeRolesState value, $Res Function(_EmployeeRolesState) _then) = __$EmployeeRolesStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, EmployeeSummary? employee, List<Role> roles, bool assigning, bool assigned, Failure? failure
});




}
/// @nodoc
class __$EmployeeRolesStateCopyWithImpl<$Res>
    implements _$EmployeeRolesStateCopyWith<$Res> {
  __$EmployeeRolesStateCopyWithImpl(this._self, this._then);

  final _EmployeeRolesState _self;
  final $Res Function(_EmployeeRolesState) _then;

/// Create a copy of EmployeeRolesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? employee = freezed,Object? roles = null,Object? assigning = null,Object? assigned = null,Object? failure = freezed,}) {
  return _then(_EmployeeRolesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,employee: freezed == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as EmployeeSummary?,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<Role>,assigning: null == assigning ? _self.assigning : assigning // ignore: cast_nullable_to_non_nullable
as bool,assigned: null == assigned ? _self.assigned : assigned // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
