part of 'inquiry_cubit.dart';

abstract class InquiryState extends Equatable {
  const InquiryState();

  @override
  List<Object> get props => [];
}

class InquiryInitial extends InquiryState {}

class LoadingInquiry extends InquiryState {}

class LoadedInquiry extends InquiryState {
  final Map inquiries;

  LoadedInquiry(this.inquiries);
}

class FailedLoadingInquiry extends InquiryState {}

class AddingInquiry extends InquiryState {}

class AddedInquiry extends InquiryState {
  final bool success;

  AddedInquiry(this.success);
}

class FailedAddingInquiry extends InquiryState {}

class UpdatingInquiry extends InquiryState {}

class UpdatedInquiry extends InquiryState {
  final bool success;

  UpdatedInquiry(this.success);
}

class FailedUpdatingInquiry extends InquiryState {}

class DeletingInquiry extends InquiryState {}

class DeletedInquiry extends InquiryState {
  final bool success;

  DeletedInquiry(this.success);
}

class FailedDeletingInquiry extends InquiryState {}
