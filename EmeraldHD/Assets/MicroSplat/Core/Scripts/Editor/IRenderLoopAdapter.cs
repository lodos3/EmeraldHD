//////////////////////////////////////////////////////
// MicroSplat
// Copyright (c) Jason Booth
//////////////////////////////////////////////////////

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Text;

namespace JBooth.MicroSplat
{
   public interface IRenderLoopAdapter 
   {
      string GetDisplayName();
      string GetRenderLoopKeyword();
      void Init(string[] paths);
      int GetNumPasses();
      void WriteShaderHeader(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader auxShader);
      void WritePassHeader(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader auxShader);
      void WriteVertexFunction(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader blend);
      void WriteFragmentFunction(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader auxShader);
      void WriteShaderFooter(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader auxShader, string baseName);
      void PostProcessShader(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader auxShader);
      void WriteSharedCode(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader auxShader);
      void WriteTerrainBody(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader auxShader);
      bool UseReplaceMethods();
      void WriteProperties(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader auxShader);
      void WritePerMaterialCBuffer(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler.AuxShader auxShader);
      string GetVersion();
   }
}
