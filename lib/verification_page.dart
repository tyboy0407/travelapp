import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_details_page.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  
  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  int _currentIndex = 0;
  int _countdown = 300; // 5分鐘 = 300秒
  bool _isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _onDigitDeleted(String value, int index) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyCode() async {
    final String code = _controllers.map((controller) => controller.text).join();
    
    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入完整的驗證碼')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 模擬驗證過程
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      
      if (!mounted) return;

      // 檢查驗證碼是否為1234
      if (code == '1234') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('驗證成功！')),
        );
        // 跳轉到註冊詳細資料頁面
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterDetailsPage(email: widget.email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('驗證碼錯誤，請重新輸入')),
        );
        // 清空所有輸入框
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('驗證失敗: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendCode() async {
    if (_countdown > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('請等待 ${_formatTime(_countdown)} 後再重新發送')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 模擬重新發送驗證碼
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      
      if (!mounted) return;

      setState(() {
        _countdown = 300; // 重置為5分鐘
      });
      _startCountdown();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('驗證碼已重新發送')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('重新發送失敗: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '驗證碼',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            // 驗證碼輸入框
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60,
                  height: 60,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      counterText: '',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (value) {
                      _onDigitChanged(value, index);
                    },
                    onTap: () {
                      _currentIndex = index;
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            // 說明文字
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: '我們已發送驗證信至 '),
                  TextSpan(
                    text: widget.email,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' 請於5分鐘內點選信內連結已完成信箱驗證'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // 下一步按鈕
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isLoading ? null : _verifyCode,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        '下一步',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            // 重新發送按鈕
            Center(
              child: TextButton(
                onPressed: _isLoading ? null : _resendCode,
                child: Text(
                  _countdown > 0 
                      ? '重新寄送 (${_formatTime(_countdown)})'
                      : '重新寄送',
                  style: TextStyle(
                    color: _countdown > 0 ? Colors.grey : Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
