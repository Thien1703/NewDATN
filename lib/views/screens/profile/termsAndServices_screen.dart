import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class TermsandservicesScreen extends StatelessWidget {
  const TermsandservicesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Điều khoản dịch vụ',
      body: Container(
        width: double.infinity,
        color: AppColors.ghostWhite,
        child: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle('GIỚI THIỆU'),
                  _buildDotBlack(
                      'Chào mừng bạn đến với phần mềm HEALTHY CARE - Đặt lịch khám bệnh (gọi chung là "Phần mềm). Vui lòng đọc kỹ các Điều Khoản Dịch Vụ sau đây trước khi tiếp tục truy cập hoặc sử dụng các dịch vụ của Phần mềm, để bạn biết được các quyền lợi và nghĩa vụ hợp pháp của mình liên quan đến Công ty cổ phần ứng dụng PKH, các Bệnh viện và các bên thứ ba có liên kết (gọi chung là "Chúng tôi" hoặc "của chúng tôi)'),
                  _buildDotBlack(
                      "'Các Dịch Vụ' của chúng tôi cung cấp hoặc phát hành bao gồm:"),
                  _buildDotWhite('Phần mềm này,'),
                  _buildDotWhite(
                      'các tính năng hoặc tiện ích được cung cấp trên Phần mềm'),
                  _buildDotWhite(
                      'mọi thông tin, các Phần mềm được liên kết, các tính năng, đồ họa, nhạc, âm thanh, video, thông báo, tag, nội dung, lập trình, phần mềm, các dịch vụ ứng dụng (bao gồm nhưng không giới hạn ở bất kỳ dịch vụ ứng dụng di động nào) hoặc cái tài liệu khác được cung cấp thông qua Phần mềm hoặc các dịch vụ liên quan của nó (gọi chung là "Nội dung). Bất kỳ tính năng mới nào được thêm vào hoặc để tăng cường Các Dịch Vụ đều phải tuân thủ các Điều Khoản Dịch Vụ này.'),
                  _buildDotBlack(
                      'BẰNG VIỆC SỬ DỤNG CÁC DỊCH VỤ HOẶC TIẾP TỤC TRUY CẬP BẰNG TRANG WEB, BẠN CHO BIẾT RẰNG BẠN CHẤP NHẬN, KHÔNG RÚT LẠI, CÁC ĐIỀU KHOẢN DỊCH VỤ NÀY. NẾU BẠN KHÔNG ĐỒNG Ý VỚI CÁC ĐIỀU KHOẢN NÀY, VUI LÒNG KHÔNG SỬ DỤNG CÁC DỊCH VỤ CỦA CHÚNG TÔI HAY TIẾP TỤC TRUY CẬP PHẦN MỀM'),
                  _buildDotBlack(
                      'Chúng tôi có quyền chỉnh sửa các Điều Khoản Dịch Vụ này vào bất kỳ lúc nào mà không cần thông báo cho người dùng. Việc bạn tiếp tục sử dụng các Dịch Vụ, Phần mềm, hoặc Tài Khoản Của Bạn sẽ được xem là chấp nhận, không rút lại đối với các điều khoản chỉnh sửa đó'),
                  _buildDotBlack(
                      'Chúng tôi có quyền thay đổi, điều chỉnh, đình chỉ hoặc ngưng bất kỳ phần nào của Phần mềm này hoặc Các Dịch Vụ bất kỳ lúc nào. Chúng tôi có thể ra mắt Các Dịch Vụ nhất định hoặc các tính năng của chúng trong một phiên bản beta, phiên bản này có thể không hoạt động chính xác hoặc theo cùng cách như phiên bản cuối cùng, và chúng tôi sẽ không chịu trách nhiệm pháp lý trong các trường hợp đó. Chúng tôi cũng có thể toàn quyền áp dụng giới hạn đối với các tính năng nhất định hoặc hạn chế quyển truy cập của bạn đối với một phần hoặc toàn bộ Phần mềm hoặc Các Dịch Vụ mà không cần thông báo hoặc phải chịu trách nhiệm pháp lý'),
                  _buildDotBlack(
                      'Chúng tôi có quyển từ chối cho phép bạn truy cập Phần mềm hoặc Các Dịch Vụ vì bất kỳ lý do gì'),
                  _buildTitle('BẢO MẬT'),
                  _buildDotBlack(
                      'Chúng tôi rẩ coi trọng việc bảo mật thông tin của bạn. Để bảo vệ các quyền của bạn một cách hiệu quả hơn, chúng tôi đã cung cấp CHính Sách Bảo Mật trên Phần mềm để giải thích chi tiết về các cách thức bảo mật thông tin của chúng tôi. Vui lòng xem Chính Sách Bảo Mật để hiểu được cách thức chúng tôi thu nhập và sử dụng thông tin liên kết với Tài Khoản của bạn và/hoặc việc bạn sử dụng các Dịch Vụ. Bằng việc sử dụng Các Dịch Vụ hoặc đồng ý cho phép chúng tôi thu nhập, sử dụng, tiết lộ và/hoặc xử lý Nội Dung và dữ liệu cá nhân của bạn như mô tả trong Chính Sách Bảo Mật của chúng tôi.'),
                  _buildDotBlack(
                      'Người dùng nào lưu dữ liệu cá nhân của một người dùng khác("Bên Nhận Thông Tin") phải:'),
                  _buildDotWhite(
                      'tuân thử mọi điều luật bảo vệ dữ liệu cá nhân hiện hành;'),
                  _buildDotWhite(
                      'phải được Bên Tiết Lộ Thông Tin cho phép truy cập và lưu giữ bằng văn bản hoặc lời nói hoặc bất kỳ một phương thức nào; và'),
                  _buildDotWhite(
                      'chỉ sử dụng thông tin của Bên Tiết Lộ Thông Tin để đăng ký sử dụng và Các Dịch Vụ giúp cho bên Tiết Lộ Thông Tin trên Phần mềm.'),
                  _buildTitle('GIỚI HẠN VỀ QUYỀN SỬ DỤNG'),
                  _buildDotBlack(
                      'Chúng tôi cung cấp cho bạn quyền sử dụng có giới hạn để truy cập và sử dụng Các Dịch Vụ tuân theo các điều khoản và điều kiện của Điều Khoản DỊch Vụ này vì mục đích sử dụng cá nhân. Việc cấp quyền không cho phép bạn sử dụng vì mục địch phái sinh đối với Các Dịch Vụ này (bao gồm nhưng không giới hạn ở bất kỳ yếu tố riêng lẻ nào hay Nội Dung của nó). Tất cả Nội Dung, thương hiệu, nhãn hiệu dịch vụ, tên thương hiệu, logo và tài sản trí tuệ khác được hiện thị trên Phần mềm đều không có quyền hoặc được chỉ rõ trên Phần mềm, nếu có. Bất kỳ đối tượng truy cập nào vào Phần mềm đều không có quyền hoặc được cấp phép một cách trực tiếp hoặc gián tiếp sử dụng hoặc sao chép bất kỳ Nội dung, thương hiệu, nhãn hiệu dịch vụ, tên thương hiệu, logo hay bất kỳ tài sản trí tuệ nào khác và cũng không có đối tượng truy cập vào Phần mềm được yêu cầu bất kỳ quyền, quyền sở hữu hay quyền lợi nào liên quan đến các đối tượng trên. Bằng việc sử dụng hoặc truy cập Các Dịch Vụ, bạn đồng ý tuân thủ các qui định pháp luật về sỡ hữu trí tuệ hiện hành oddois với vấn đề bảo hộ bản quyền, thương hiệu, nhãn hiệu dịch vụ. Các Dịch Vụ, Phần mềm và Nội Dung của nó. Bạn đông ý không sao chép, phát tán ,tái xuất bản, gửi trưng bày công khai, trình diễn công khai, điều chỉnh, sửa đổi, cho thuê, bán, hay tạo phó bản của bất kỳ phần nào của Các Dịch Vụ, Phần mềm hoặc Nội Dung của nó. Nếu không có sự đồng ý trước bằng văn bản của chúng tôi, Bạn cũng không được nhân bản hoặc chỉnh sửa một phần hay toàn bộ nội dung của Phần mềm này trên máy chủ khác hoặc như như một phần của bất kỳ Phần mềm nào khác. Ngoài ra, bạn đồng ý rằng sẽ không sử dụng bất kỳ thiết bị tự đọng  hay quy trình thủ công nào khác để theo dõi hay sao chép Nội Dung của chúng tôi, nếu không có sự đồng ý trước bằng văn bản của chúng tôi (thỏa thuận này áp dụng cho các công cụ tìm kiếm cơ bản trên các webside kết nối người dùng trực tiếp đến webside đó).'),
                  _buildDotBlack(
                      'Chúng tôi hoan nghệnh bạn liên kết đến Phần mềm này từ Phần mềm của bạn, miễn là Phần mềm của bạn không ngụ ý rằng Chúng tôi ủng hộ hay liến kết với Phần mềm nào của bạn. Bạn thừa nhận rằng Chúng tôi, vào bất kỳ lúc nào, có thể tự quyền quyết định về việc ngưng cung cấp bất kỳ phần nào của Các Dịch Vụ mà không cần thông báo'),
                  _buildTitle('PHẦN MÈM'),
                  _buildDotBlack(
                      'Trừ phi kèm theo một hỏa thuận cấp phép riêng, bất kỳ phần mềm nào được chúng tôi cung cấp cho bạn như một phần của Các Dịch Vụ sẽ tuân thủ các điều khoản của Điều Khoản Dịch Vụ này. Phần mềm được cấp phép sử dụng, không bán, và Chúng tôi bảo lưu tất cả quyền đối với phần mềm mà Chúng tôi không cấp. Bất kỳ lệnh hay mã nào của bên thứ ba, được liên kết đến hoặc được tham chieesy từ Các DỊch Vụ, đều được cấp phép cho bạn bởi các bên thứ ba sở hữu các mã script hoặc mã đó, không phải bởi Chúng tôi.'),
                  _buildTitle("TÀI KHOẢN VÀ BẢO MẬT**"),
                  _buildDotBlack(
                      'Chúng tôi có quyền thay đổi, điều chỉnh, đình chỉ hoặc ngưng bất kỳ phần nào của Phần mềm này hoặc Các Dịch Vụ bất kỳ lúc nào. Chúng tôi có thể ra mắt Các Dịch Vụ nhất định hoặc các tính năng của chúng trong một phiên bản beta, phiên bản này có thể không hoạt động chính xác hoặc theo cùng cách như phiên bản cuối cùng, và chúng tôi sẽ không chịu trách nhiệm pháp lý trong các trường hợp đó. Chúng tôi cũng có thể toàn quyền áp dụng giới hạn đối với các tính năng nhất định hoặc hạn chế quyển truy cập của bạn đối với một phần hoặc toàn bộ Phần mềm hoặc Các Dịch Vụ mà không cần thông báo hoặc phải chịu trách nhiệm pháp lý'),
                  _buildDotBlack('Bạn đồng ý'),
                  _buildDotWhite(
                      'bảo mật thông tin Tài Khoản của bạn và chỉ sử dụng ID Người Dùng của bạn khi đăng nhập'),
                  _buildDotWhite(
                      'đảm bảo rằng bạn đăng xuất ra khỏi tài khoản của mình vào cuối mỗi phiên truy cập trên Phần mềm'),
                  _buildDotWhite(
                      'thông báo ngay cho Chúng tôi bất kỳ trường hợp nào sử dụng trái phép ID Người Dùng và/hoặc thông tin của bạn'),
                  _buildDotWhite(
                      'mọi thông tin, các Phần mềm được liên kết, các tính năng, đồ họa, nhạc, âm thanh, video, thông báo, tag, nội dung, lập trình, phần mềm, các dịch vụ ứng dụng (bao gồm nhưng không giới hạn ở bất kỳ dịch vụ ứng dụng di động nào) hoặc cái tài liệu khác được cung cấp thông qua Phần mềm hoặc các dịch vụ liên quan của nó (gọi chung là "Nội dung). Bất kỳ tính năng mới nào được thêm vào hoặc để tăng cường Các Dịch Vụ đều phải tuân thủ các Điều Khoản Dịch Vụ này.'),
                  _buildDotBlack(
                      'Bạn đồng ý rằng Chúng tôi có thể, vì bất kỳ lý do, tự quyền quyết định và không cần thông báo hay chịu trách nhiệm pháp lý đối với bạn hay bất kỳ bên thứ ba nào, ngay lập tức chấm dút Tài Khoản và ID Người Dùng của bạn, và xóa gỡ bỏ bất kỳ Nội Dung của bạn ra khỏi trang Web. Căn cứ chấm dứt tài khoản có thể bao gồm, nhưng không giới hạn:'),
                  _buildDotWhite(
                      'vi phạm hoặc tinh thần của các Điều Khoản DỊch Vụ này.'),
                  _buildDotWhite(
                      'có hành vi gian lận, quấy rối, lăng mạ, đe dọa hoặc xúc phạm hoặc'),
                  _buildDotWhite(
                      'có hành vi gây hại cho người dùng khác, các bên thứ ba, hoặc lợi ích cho Chúng tôi. Hành vi sử dụng Tài Khoản cho mục đích phi pháp, gian lận, quấy rối, lăng mạ, đe dọa, hay xúc phạm có thể bị báo cáo cho các cơ quan thực thi pháp luật mà không cần thông báo cho bạn'),
                  _buildTitle('CÁC KHOẢN PHÍ VÀ THANH TOÁN'),
                  _buildDotBlack(
                      'Chúng tôi có quyền chỉnh sửa các Điều Khoản Dịch Vụ này vào bất kỳ lúc nào mà không cần thông báo cho người dùng. Việc bạn tiếp tục sử dụng các Dịch Vụ, Phần mềm, hoặc Tài Khoản Của Bạn sẽ được xem là chấp nhận, không rút lại đối với các điều khoản chỉnh sửa đó'),
                  _buildDotBlack(
                      'Chúng tôi có quyền thay đổi, điều chỉnh, đình chỉ hoặc ngưng bất kỳ phần nào của Phần mềm này hoặc Các Dịch Vụ bất kỳ lúc nào. Chúng tôi có thể ra mắt Các Dịch Vụ nhất định hoặc các tính năng của chúng trong một phiên bản beta, phiên bản này có thể không hoạt động chính xác hoặc theo cùng cách như phiên bản cuối cùng, và chúng tôi sẽ không chịu trách nhiệm pháp lý trong các trường hợp đó. Chúng tôi cũng có thể toàn quyền áp dụng giới hạn đối với các tính năng nhất định hoặc hạn chế quyển truy cập của bạn đối với một phần hoặc toàn bộ Phần mềm hoặc Các Dịch Vụ mà không cần thông báo hoặc phải chịu trách nhiệm pháp lý'),
                  _buildDotBlack(
                      'Bằng việc cung cấp một phương thức thanh toán cho Chúng tôi, bạn:'),
                  _buildDotWhite(
                      'đảm bảo rằng bạn được phép sử dụng phương thức thanh toán mà bạn cung cập và rằng bất kỳ thông tin thanh toán nào bạn cung cấp đều là đúng sự thực và chính xác'),
                  _buildDotWhite(
                      'cho phép Chúng tôi tính phí cho bạn đối với Các Dịch Vụ, dùng phương thức thanh toán mà bạn lựa chọn; và'),
                  _buildDotWhite(
                      'cho phép Chung tôi tính phí cho bạn đối với bất kỳ tính năng có trả phí nào của Các Dịch Vụ mà bạn lựa chọn đăng ký hoặc sử dụng trong thời gian các Điều Khoản Dịch Vụ này có hiệu lực'),
                  _buildDotBlack(
                      'Tùy vào bản chất của giao dịch, chúng tôi có thể gửi hóa đơn cho bạn'),
                  _buildDotWhite('tại thời điểm đăng ký sử dụng dịch vụ'),
                  _buildDotWhite(
                      'hoặc sau khi đăng ký sử dụng dịch vụ hoàn tất'),
                  _buildTitle('LOẠI TRỪ TRÁCH NHIỆM'),
                  _buildDotBlack(
                      'Chúng tôi có quyền chỉnh sửa các Điều Khoản Dịch Vụ này vào bất kỳ lúc nào mà không cần thông báo cho người dùng. Việc bạn tiếp tục sử dụng các Dịch Vụ, Phần mềm, hoặc Tài Khoản Của Bạn sẽ được xem là chấp nhận, không rút lại đối với các điều khoản chỉnh sửa đó'),
                  _buildDotBlack(
                      'Chúng tôi có quyền thay đổi, điều chỉnh, đình chỉ hoặc ngưng bất kỳ phần nào của Phần mềm này hoặc Các Dịch Vụ bất kỳ lúc nào. Chúng tôi có thể ra mắt Các Dịch Vụ nhất định hoặc các tính năng của chúng trong một phiên bản beta, phiên bản này có thể không hoạt động chính xác hoặc theo cùng cách như phiên bản cuối cùng, và chúng tôi sẽ không chịu trách nhiệm pháp lý trong các trường hợp đó. Chúng tôi cũng có thể toàn quyền áp dụng giới hạn đối với các tính năng nhất định hoặc hạn chế quyển truy cập của bạn đối với một phần hoặc toàn bộ Phần mềm hoặc Các Dịch Vụ mà không cần thông báo hoặc phải chịu trách nhiệm pháp lý'),
                  _buildTitle(
                      "CÁC TRƯỜNG HỢP LOẠI TRỪ VÀ GIỚI HẠN TRÁCH NHIỆM PHÁP LÝ"),
                  _buildDotBlack(
                      'Chúng tôi có quyền chỉnh sửa các Điều Khoản Dịch Vụ này vào bất kỳ lúc nào mà không cần thông báo cho người dùng. Việc bạn tiếp tục sử dụng các Dịch Vụ, Phần mềm, hoặc Tài Khoản Của Bạn sẽ được xem là chấp nhận, không rút lại đối với các điều khoản chỉnh sửa đó'),
                  _buildDotBlack(
                      'Chúng tôi có quyền thay đổi, điều chỉnh, đình chỉ hoặc ngưng bất kỳ phần nào của Phần mềm này hoặc Các Dịch Vụ bất kỳ lúc nào. Chúng tôi có thể ra mắt Các Dịch Vụ nhất định hoặc các tính năng của chúng trong một phiên bản beta, phiên bản này có thể không hoạt động chính xác hoặc theo cùng cách như phiên bản cuối cùng, và chúng tôi sẽ không chịu trách nhiệm pháp lý trong các trường hợp đó. Chúng tôi cũng có thể toàn quyền áp dụng giới hạn đối với các tính năng nhất định hoặc hạn chế quyển truy cập của bạn đối với một phần hoặc toàn bộ Phần mềm hoặc Các Dịch Vụ mà không cần thông báo hoặc phải chịu trách nhiệm pháp lý'),
                  _buildDotBlack('LIÊN KẾT ĐẾN CÁC TRANG CỦA BÊN THỨ BA'),
                  _buildDotBlack(
                      'Chúng tôi có quyền chỉnh sửa các Điều Khoản Dịch Vụ này vào bất kỳ lúc nào mà không cần thông báo cho người dùng. Việc bạn tiếp tục sử dụng các Dịch Vụ, Phần mềm, hoặc Tài Khoản Của Bạn sẽ được xem là chấp nhận, không rút lại đối với các điều khoản chỉnh sửa đó'),
                  _buildDotBlack(
                      'Chúng tôi có quyền thay đổi, điều chỉnh, đình chỉ hoặc ngưng bất kỳ phần nào của Phần mềm này hoặc Các Dịch Vụ bất kỳ lúc nào. Chúng tôi có thể ra mắt Các Dịch Vụ nhất định hoặc các tính năng của chúng trong một phiên bản beta, phiên bản này có thể không hoạt động chính xác hoặc theo cùng cách như phiên bản cuối cùng, và chúng tôi sẽ không chịu trách nhiệm pháp lý trong các trường hợp đó. Chúng tôi cũng có thể toàn quyền áp dụng giới hạn đối với các tính năng nhất định hoặc hạn chế quyển truy cập của bạn đối với một phần hoặc toàn bộ Phần mềm hoặc Các Dịch Vụ mà không cần thông báo hoặc phải chịu trách nhiệm pháp lý'),
                  _buildTitle('VI PHẠM CÁC ĐIỀU KHOẢN DỊCH VỤ CỦA CHÚNG TÔI'),
                  _buildDotBlack(
                      'Nếu bạn cho rằng một người dùng trên Phần mềm của chúng tôi đang vị phạm các Điều Khoản Dịch Vụ, vui lòng liên hệ với chúng tôi qua email hotro@gmail.com'),
                  _buildTitle('LUẬT ĐIỀU CHỈNH'),
                  _buildDotBlack(
                      'Các Điều Khoản Dịch Vụ này sẽ được điều chỉnh bởi và được giải nghĩa theo luật pháp Cộng Hòa Xã Hội Chủ Nghĩa Việt Nam'),
                  _buildTitle('CÁC QUY ĐỊNH CHUNG'),
                  _buildDotBlack(
                      'Chúng tôi có quyền chỉnh sửa các Điều Khoản Dịch Vụ này vào bất kỳ lúc nào mà không cần thông báo cho người dùng. Việc bạn tiếp tục sử dụng các Dịch Vụ, Phần mềm, hoặc Tài Khoản Của Bạn sẽ được xem là chấp nhận, không rút lại đối với các điều khoản chỉnh sửa đó'),
                  _buildDotBlack(
                      'Chúng tôi có quyền thay đổi, điều chỉnh, đình chỉ hoặc ngưng bất kỳ phần nào của Phần mềm này hoặc Các Dịch Vụ bất kỳ lúc nào. Chúng tôi có thể ra mắt Các Dịch Vụ nhất định hoặc các tính năng của chúng trong một phiên bản beta, phiên bản này có thể không hoạt động chính xác hoặc theo cùng cách như phiên bản cuối cùng, và chúng tôi sẽ không chịu trách nhiệm pháp lý trong các trường hợp đó. Chúng tôi cũng có thể toàn quyền áp dụng giới hạn đối với các tính năng nhất định hoặc hạn chế quyển truy cập của bạn đối với một phần hoặc toàn bộ Phần mềm hoặc Các Dịch Vụ mà không cần thông báo hoặc phải chịu trách nhiệm pháp lý'),
                  SizedBox(height: 10),
                  Text(
                    'TÔI ĐÃ ĐỌC THỎA THUẬN NÀY VÀ ĐỒNG Ý VỚI TẤT CẢ CÁC QUY ĐỊNH CÓ TRONG NỘI DUNG BÊN TRÊN VÀ BẤT KỲ BẢN CHỈNH SỬA NÀO CỦA NỘI DUNG BÊN TRÊN SAU NÀY. BẰNG VIỆC TIẾP TỤC TRUY CẬP VÀ SỬ DỤNG PHẦN MỀM, TÔI HIERU RẰNG TÔI ĐANG TẠO RA MỘT CHỮ KÝ ĐIỆN TỬ MÀ NÓ CÓ GIÁ TRỊ VÀ HIỆU LỰC TƯƠNG TỰ NHƯ CHỮ KÝ TÔI KÝ BẰNG TAY.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Cập nhật gần nhất: 19/04/2025',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 19,
        ),
      ),
    );
  }

  Widget _buildDotBlack(String label) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10, top: 5),
            child: Icon(
              Icons.circle,
              color: Colors.black,
              size: 9,
            ),
          ),
          Expanded(
            child: Text(
              label,
              softWrap: true,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotWhite(String label) {
    return Container(
      margin: EdgeInsets.only(left: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10, top: 5),
            child: Icon(
              Icons.circle_outlined,
              color: Colors.black,
              size: 9,
            ),
          ),
          Expanded(
            child: Text(
              label,
              softWrap: true,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
